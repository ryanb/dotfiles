---
name: standup
description: Summarize work done since the last standup across the user's configured repos — merged PRs, open PR reviews, PRs/commits authored, and a per-repo summary of code changes.
user-invocable-only: true
allowed-tools: Bash, Read, Grep, Glob
argument-hint: [optional since date override, e.g. "yesterday", "last friday", "2 days ago"]
---

# standup — Summarize work since last standup

Summarize work done in the user's configured repo directory since the last standup, grouped by category. The output is meant to be read aloud at a standup, so keep it concise.

**Priority of the output — put the user's own work first:**
1. PRs the user created within the window (any state).
2. Other PRs the user authored that had activity in the window (updates, new commits, state changes).
3. Activity on other people's PRs (reviews, merges, comments).
4. Local branches with a summary of **the user's own** commits (ignore commits by others).

## Step 1: Load configuration

Read `~/.claude/standup.json`. If the file does not exist, stop and instruct the user to create it with this shape:

```json
{
  "base_path": "~/code/your-project-root",
  "default_branch": "main",
  "preferences": "Optional freeform instructions applied to the output."
}
```

Only `base_path` is required. Extract the values with `jq`:

```bash
config=~/.claude/standup.json
base_path=$(jq -r '.base_path // empty' "$config")
default_branch=$(jq -r '.default_branch // "main"' "$config")
preferences=$(jq -r '.preferences // empty' "$config")
# Expand a leading ~ in base_path
base_path="${base_path/#\~/$HOME}"
```

If `base_path` is empty, stop with an error.

## Step 2: Determine the since date

Priority:
1. If `$ARGUMENTS` is non-empty, use it verbatim as the since date.
2. Else if `~/.claude/standup-last-timestamp` exists, read its contents and use that as the since date. The file stores an ISO 8601 timestamp written by a previous run of this skill.
3. Else default to `24 hours ago`.

Store the chosen value in `$since`. Also compute a **full ISO 8601 timestamp** for `gh search` — GitHub search accepts `>=YYYY-MM-DDTHH:MM:SSZ`, and we want time-of-day precision so reruns in the same day don't re-list already-reported PRs.

```bash
# If $since is already an ISO timestamp (from the last-timestamp file), normalize to UTC Z form.
# Otherwise resolve the relative phrase via BSD date.
if [[ "$since" == ????-??-??T* ]]; then
  # e.g. 2026-04-13T11:11:39-0700 → 2026-04-13T18:11:39Z
  since_ts=$(date -j -u -f "%Y-%m-%dT%H:%M:%S%z" "$since" +%Y-%m-%dT%H:%M:%SZ)
else
  # Parse forms like "36 hours ago", "24 hours ago", "2 days ago", "yesterday",
  # "last friday", "past 36 hours" — normalize to BSD `date -v` adjustments.
  case "$since" in
    "yesterday")                  adj="-1d" ;;
    "last friday")                adj="-fri" ;;
    *"hour"*|*"hours"*)           n=$(echo "$since" | grep -oE '[0-9]+'); adj="-${n}H" ;;
    *"day"*|*"days"*)             n=$(echo "$since" | grep -oE '[0-9]+'); adj="-${n}d" ;;
    *"week"*|*"weeks"*)           n=$(echo "$since" | grep -oE '[0-9]+'); adj="-${n}w" ;;
    *)                            adj="-1d" ;;  # safe default
  esac
  since_ts=$(date -j -u -v"$adj" +%Y-%m-%dT%H:%M:%SZ)
fi
```

Use `$since_ts` for all `gh search` `>=` filters. For `git log --since=`, pass `$since` verbatim (git accepts both relative phrases and ISO timestamps).

## Step 3: Determine identities

You need two separate identities:

- **GitHub login** (for `gh search` and filtering reviewed-by results):
  ```bash
  login=$(gh api user --jq .login)
  ```
- **Git author email** (for `git log --author` — the GitHub login usually does NOT match the git author name/email):
  ```bash
  email=$(git -C <any-repo-from-step-4> config user.email)
  ```

## Step 4: Find recently-changed repos

```bash
~/.claude/skills/standup/find-repos.sh "$base_path" "$since"
```

This prints absolute paths of git repos under `$base_path` that have any commits since the given date.

## Step 5: Gather data

Run these in parallel where possible.

**Per repo from Step 4** — commits authored by the user on the current branch (not `--all`, which produces duplicates from post-rebase branch tips):

```bash
git -C <repo> log --author="$email" --since="<since>" \
    --pretty=format:"%h%x09%s" --no-merges
```

Also capture a short stat to summarize changes:

```bash
git -C <repo> log --author="$email" --since="<since>" \
    --no-merges --pretty=format:"%n---%n%h %s%n" --stat
```

**PRs (global `gh search`, limited to the relevant orgs)** — identify the orgs by looking at remotes of the repos found in Step 4 (e.g. `git -C <repo> remote get-url origin` → extract `owner`). Collect distinct owners and pass one `--owner` flag per owner.

Important `gh search prs` flag quirks:
- `--merged` is a **boolean**, not a date. Use `--merged --merged-at=">=$since_ts"` together.
- `gh search prs` JSON has no `mergedAt` field for open queries — use `updatedAt` instead.
- `--reviewed-by=@me` / `--commenter=@me` include your own PRs if you acted on them — always filter `author.login != $login` when looking for "other people's PRs".

### 5a. PRs the user authored

- **Created in window** (the priority #1 bucket):
  ```bash
  gh search prs --author=@me --created=">=$since_ts" \
      --owner <owner1> --owner <owner2> \
      --json title,url,repository,state,isDraft,createdAt,updatedAt --limit 50
  ```
- **Authored & updated in window** (priority #2 — any state, including merged, closed, draft). De-dup against the "created in window" set by URL so each PR appears once:
  ```bash
  gh search prs --author=@me --updated=">=$since_ts" \
      --owner <owner1> --owner <owner2> \
      --json title,url,repository,state,isDraft,createdAt,updatedAt --limit 100
  ```

### 5b. Activity on other people's PRs (priority #3)

Run each query, filter out `author.login == $login`, then merge + de-dup by URL. Track which bucket(s) each PR came from so the output can label the action(s) taken.

- **Reviewed** (any state — open, merged, or closed):
  ```bash
  gh search prs --reviewed-by=@me --updated=">=$since_ts" \
      --owner <owner1> --owner <owner2> \
      --json title,url,repository,author,state,updatedAt --limit 50 \
    | jq --arg me "$login" '[.[] | select(.author.login != $me)]'
  ```
- **Commented**:
  ```bash
  gh search prs --commenter=@me --updated=">=$since_ts" \
      --owner <owner1> --owner <owner2> \
      --json title,url,repository,author,state,updatedAt --limit 50 \
    | jq --arg me "$login" '[.[] | select(.author.login != $me)]'
  ```
- **Merged while the user was involved** — catches PRs the user merged, plus merged PRs they reviewed/commented on. `gh search` has no `merged-by` filter, so use `--involves=@me` and cross-reference:
  ```bash
  gh search prs --involves=@me --merged --merged-at=">=$since_ts" \
      --owner <owner1> --owner <owner2> \
      --json title,url,repository,author,updatedAt --limit 50 \
    | jq --arg me "$login" '[.[] | select(.author.login != $me)]'
  ```
  For each PR in this set that was **not** already tagged as reviewed/commented (i.e. the user's only involvement was the merge itself), fetch `mergedBy` to confirm — this is usually a short list:
  ```bash
  gh pr view <url> --json mergedBy --jq '.mergedBy.login'
  ```
  If `mergedBy == $login`, tag the PR as "merged". Otherwise drop it (the user was merely mentioned/assigned).

If `gh` fails (not authed, etc.), report the error and continue with the git data.

## Step 6: Output

Produce a markdown report in **this exact section order** — the user's own work leads, then activity on others' PRs, then local branch work. Omit any section that ends up empty. Use clickable links for PRs (`[title](url)`). Keep each bullet to one line.

```
# Standup — since <since>

## My PRs — created
- [<title>](<url>) — <repo> (<state>)

## My PRs — updated
- [<title>](<url>) — <repo> (<state>)

## Activity on others' PRs
- [<title>](<url>) — <repo> (by @<author>, <actions>)

## Code changes by repo
### <repo>
- **`<branch-name>`** — <1-sentence summary of the user's commits on this branch>
- **`<branch-name>`** — <1-sentence summary>
```

Rules for the PR sections:

- **My PRs — created**: PRs authored by the user with `createdAt >= $since_ts`. Show `<state>` as `open`, `draft`, `merged`, or `closed`.
- **My PRs — updated**: PRs authored by the user with `updatedAt >= $since_ts` that are **not** already in the "created" section. Same state label.
- **Activity on others' PRs**: union of the reviewed / commented / merged sets from Step 5b, de-duplicated by URL. For each PR, list the action(s) the user took, comma-separated, e.g. `(by @drnic, reviewed, merged)`. Include the PR's current state inside the actions list only if it adds information (e.g. `merged` already implies state).

**Branch-summary rule:** one bullet **per branch** — every local branch in the repo that was updated since `$since`. Do not merge multiple branches into a single bullet. Each bullet is the branch name followed by a brief human-language summary of what **the user** changed (not a raw list of commit messages). Commits authored by other people on the same branch must be ignored — see Step 5 for the `--author="$email"` filter that enforces this.

Identify candidate branches using **git only** (no `gh`):

```bash
# List local branches whose tip commit is newer than $since_ts (ISO 8601).
git -C <repo> for-each-ref refs/heads/ \
    --format='%(committerdate:iso-strict)%x09%(refname:short)' \
  | awk -v ts="$since_ts" 'BEGIN{FS="\t"} $1 >= ts {print $2}'
```

For each branch returned, list the commits on it authored by the user that aren't on the repo's default branch (detect via `git symbolic-ref refs/remotes/origin/HEAD`; if that fails, fall back to `$default_branch` from config):

```bash
default=$(git -C <repo> symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
default="${default:-$default_branch}"

git -C <repo> log "$branch" "^$default" \
    --author="$email" --since="$since" \
    --pretty=format:"%s" --no-merges
```

If the branch IS the default branch, use `--since` alone (no `^default` exclusion) to capture direct commits there.

Feed the resulting commit subjects into a one-sentence human summary per branch — e.g. "Aborts in-flight checkout async ops on unmount; consolidates cleanup refs and fixes a stale paymentSettings closure."

Skip branches that end up with no commits by the user in the window.

## Step 7: Apply preferences

If `$preferences` is non-empty, apply those instructions to the report — reorder, exclude, group, highlight, or rephrase sections as described. Preserve the markdown structure and link format.

## Step 8: Update the timestamp

After successfully producing the report, write the current time (ISO 8601, with timezone offset) to `~/.claude/standup-last-timestamp` so the next run picks up from here:

```bash
date +%Y-%m-%dT%H:%M:%S%z > ~/.claude/standup-last-timestamp
```

Write the timestamp whenever the report was produced without fatal errors, including when the user passed an explicit `$ARGUMENTS` override.
