"        File: snippetsEmu.vim
"      Author: Felix Ingram
"              ( f.ingram.lists <AT> gmail.com )
" Description: An attempt to implement TextMate style Snippets. Features include
"              automatic cursor placement and command execution.
" $LastChangedDate$
" Version:     1.1
" $Revision$
"
" This file contains some simple functions that attempt to emulate some of the 
" behaviour of 'Snippets' from the OS X editor TextMate, in particular the
" variable bouncing and replacement behaviour.
"
" {{{ USAGE:
"
" Place the file in your plugin directory.
" Define snippets using the Snippet command.
" Snippets are best defined in the 'after' subdirectory of your Vim home
" directory ('~/.vim/after' on Unix). Filetype specific snippets can be defined
" in '~/.vim/after/ftplugin/<filetype>_snippets.vim. Using the <buffer> argument will
" By default snippets are buffer specific. To define general snippets available
" globally use the 'Iabbr' command.
"
" Example One:
" Snippet fori for <{datum}> in <{data}>:<CR><{datum}>.<{}>
"
" The above will expand to the following (indenting may differ):
" 
" for <{datum}> in <{data}>:
"   <{datum}>.<{}>
" 
" The cursor will be placed after the first '<{' in insert mode.
" Pressing <Tab> will 'tab' to the next place marker (<{data}>) in
" insert mode.  Adding text between <{ and }> and then hitting <{Tab}> will
" remove the angle brackets and replace all markers with a similar identifier.
"
" Example Two:
" With the cursor at the pipe, hitting <Tab> will replace:
" for <{MyVariableName|datum}> in <{data}>:
"   <{datum}>.<{}>
"
" with (the pipe shows the cursor placement):
"
" for MyVariableName in <{data}>:
"   MyVariableName.<{}>
" 
" Enjoy.
"
" For more information please see the documentation accompanying this plugin.
"
" Additional Features:
"
" Commands in tags. Anything after a ':' in a tag will be run with Vim's
" 'execute' command. The value entered by the user (or the tag name if no change
" has been made) is passed in the @z register (the original contents of the
" register are restored once the command has been run).
"
" Named Tags. Naming a tag (the <{datum}> tag in the example above) and changing
" the value will cause all other tags with the same name to be changed to the
" same value (as illustrated in the above example). Not changing the value and
" hitting <Tab> will cause the tag's name to be used as the default value.
"
" Test tags for pattern matching:
" The following are examples of valid and invalid tags. Whitespace can only be
" used in a tag name if the name is enclosed in quotes.
"
" Valid tags
" <{}>
" <{tagName}>
" <{tagName:command}>
" <{"Tag Name"}>
" <{"Tag Name":command}>
"
" Invalid tags, random text
" <{:}>
" <{:command}>
" <{Tag Name}>
" <{Tag Name:command}>
" <{"Tag Name":}>
" <{Tag }>
" <{OpenTag
"
" Here's our magic search term (assumes '<{',':' and '}>' as our tag delimiters:
" <{\([^[:punct:] \t]\{-}\|".\{-}"\)\(:[^}>]\{-1,}\)\?}>
" }}}

if v:version < 700
  echomsg "snippetsEmu plugin requires Vim version 7 or later"
  finish
endif

if globpath(&rtp, 'plugin/snippetEmu.vim') != ""
  call confirm("It looks like you've got an old version of snippetsEmu installed. Please delete the file 'snippetEmu.vim' from the plugin directory. Note lack of 's'")
endif

let s:debug = 0
let s:Disable = 0

function! s:Debug(func, text)
  if exists('s:debug') && s:debug == 1
    echom "Snippy: ".a:func.": ".a:text
  endif
endfunction

if (exists('loaded_snippet') || &cp) && !s:debug
  finish
endif

"call s:Debug("","Started the plugin")

let loaded_snippet=1
" {{{ Set up variables
if !exists("g:snip_start_tag")
    let g:snip_start_tag = "<{"
endif

if !exists("g:snip_end_tag")
    let g:snip_end_tag = "}>"
endif

if !exists("g:snip_elem_delim")
    let g:snip_elem_delim = ":"
endif

if !exists("g:snippetsEmu_key")
  let g:snippetsEmu_key = "<Tab>"
endif

"call s:Debug("", "Set variables")

" }}}
" {{{ Set up menu
for def_file in split(globpath(&rtp, "after/ftplugin/*_snippets.vim"), '\n')
  "call s:Debug("","Adding ".def_file." definitions to menu")
  let snip = substitute(def_file, '.*[\\/]\(.*\)_snippets.vim', '\1', '')
  exec "nmenu <silent> S&nippets.".snip." :source ".def_file."<CR>"
endfor
" }}}
" {{{ Sort out supertab
function! s:GetSuperTabSNR()
  let a_sav = @a
  redir @a
  exec "silent function"
  redir END
  let funclist = @a
  let @a = a_sav
  try
    let func = split(split(matchstr(funclist,'.SNR.\{-}SuperTab(command)'),'\n')[-1])[1]
    return matchlist(func, '\(.*\)S')[1]
  catch /E684/
  endtry
  return ""
endfunction

function! s:SetupSupertab()
  if !exists('s:supInstalled')
    let s:supInstalled = 0
  endif
  if s:supInstalled == 1 || globpath(&rtp, 'plugin/supertab.vim') != ""
    "call s:Debug("SetupSupertab", "Supertab installed")
    let s:SupSNR = s:GetSuperTabSNR()
    let s:supInstalled = 1
    if s:SupSNR != ""
      let s:done_remap = 1
    else
      let s:done_remap = 0
    endif
  endif
endfunction

call s:SetupSupertab()
" }}}
" {{{ Map Jumper to the default key if not set already
function! s:SnipMapKeys()
  if (!hasmapto('<Plug>Jumper','i'))
    if s:supInstalled == 1
      exec 'imap '.g:snippetsEmu_key.' <Plug>Jumper'
    else
      exec 'imap <unique> '.g:snippetsEmu_key.' <Plug>Jumper'
    endif
  endif

  if (!hasmapto( 'i<BS>'.g:snippetsEmu_key, 's'))
    exec 'smap <unique> '.g:snippetsEmu_key.' i<BS>'.g:snippetsEmu_key
  endif
  imap <silent> <script> <Plug>Jumper <C-R>=<SID>Jumper()<CR>
endfunction

call s:SnipMapKeys()

"call s:Debug("", "Mapped keys")

" }}}
" {{{ SetLocalTagVars()
function! s:SetLocalTagVars()
  if exists("b:snip_end_tag") && exists("b:snip_start_tag") && exists("b:snip_elem_delim")
    return [b:snip_start_tag, b:snip_elem_delim, b:snip_end_tag]
  else
    return [g:snip_start_tag, g:snip_elem_delim, g:snip_end_tag]
  endif
endfunction
" }}}
" {{{ SetSearchStrings() - Set the search string. Checks for buffer dependence
function! s:SetSearchStrings()
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  let b:search_str = snip_start_tag.'\([^'.
        \snip_start_tag.snip_end_tag.
        \'[:punct:] \t]\{-}\|".\{-}"\)\('.
        \snip_elem_delim.
        \'[^'.snip_end_tag.snip_start_tag.']\{-1,}\)\?'.snip_end_tag
  let b:search_commandVal = "[^".snip_elem_delim."]*"
  let b:search_endVal = "[^".snip_end_tag."]*"
endfunction
" }}}
" {{{ SetCom(text, scope) - Set command function
function! <SID>SetCom(text, scope)
  let text = substitute(a:text, '\c<CR>\|<Esc>\|<Tab>\|<BS>\|<Space>\|<C-r>\|<Bar>\|\"\|\\','\\&',"g")

  if s:supInstalled == 1
    call s:SetupSupertab()
    call s:SnipMapKeys()
  endif

  let text = substitute(text, "\r$", "","")

  let tokens = split(text, ' ')
  call filter(tokens, 'v:val != ""')
  if len(tokens) == 0
    let output = join(s:ListSnippets("","","",eval(a:scope)) ,"\n")
    if output == ""
      echohl Title | echo "No snippets defined" | echohl None
    else
      echohl Title | echo "Defined snippets:" | echohl None
      echo output
    endif
  " NOTE - cases such as ":Snippet if  " will intentionally(?) be parsed as a
  " snippet named "if" with contents of " "
  elseif len(tokens) == 1
    let snip = s:Hash(tokens[0])
    if exists(a:scope."trigger_".snip)
      " FIXME - is there a better approach?
      " echo doesn't handle ^M correctly
      let pretty = substitute(eval(a:scope."trigger_".snip), "\r", "\n","g")
      echo pretty
    else
      echohl Error | echo "Undefined snippet: ".snip | echohl None
    endif
  else
    let [lhs, rhs] = [s:Hash(tokens[0]), join(tokens[1:])] 
    call s:SetSearchStrings()
    let g:search_str = b:search_str
    exe "let ".a:scope."trigger_".lhs.' = "'.rhs.'"'
  endif
endfunction
" }}}
" {{{ RestoreSearch()
" Checks whether more tags exist and restores hlsearch and @/ if not
function! s:RestoreSearch()
  if !search(b:search_str, "n")
    if exists("b:hl_on") && b:hl_on == 1
      setlocal hlsearch
    endif
    if exists("b:search_sav")
      let @/ = b:search_sav
    endif
  endif
endfunction
"}}}
" {{{ DeleteEmptyTag 
function! s:DeleteEmptyTag()
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  exec "normal zv".(s:StrLen(snip_start_tag) + s:StrLen(snip_end_tag))."x"
endfunction
" }}}
" {{{ SetUpTags()
function! s:SetUpTags()
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  if (strpart(getline("."), col(".")+strlen(snip_start_tag)-1, strlen(snip_end_tag)) == snip_end_tag)
    "call s:Debug("SetUpTags","Found an empty tag")
    let b:tag_name = ""
    if col(".") + s:StrLen(snip_start_tag.snip_end_tag) == s:StrLen(getline("."))
      " We delete the empty tag here as otherwise we can't determine whether we
      " need to send 'a' or 'A' as deleting the empty tag will sit us on the
      " final character either way
      call s:DeleteEmptyTag()
      call s:RestoreSearch()
      if col(".") == s:StrLen(getline("."))
        return "\<Esc>a"
      endif
    else
      call s:DeleteEmptyTag()
      call s:RestoreSearch()
      if col(".") == s:StrLen(getline("."))
        return "\<Esc>A"
      endif
    endif
    return ''
  else
    " Not on an empty tag so it must be a normal tag
    let b:tag_name = s:ChopTags(matchstr(getline("."),b:search_str,col(".")-1))
    "call s:Debug("SetUpTags","On a tag called: ".b:tag_name)

"    Check for exclusive selection mode. If exclusive is not set then we need to
"    move back a character.
    if &selection == "exclusive"
      let end_skip = ""
    else
      let end_skip = "\<Left>"
    endif

    let start_skip = repeat("\<Right>",s:StrLen(snip_start_tag)+1)
    "call s:Debug("SetUpTags","Start skip is: ".start_skip)
    "call s:Debug("SetUpTags","Col() is: ".col("."))
    if col(".") == 1
      "call s:Debug("SetUpTags","We're at the start of the line so don't need to skip the first char of start tag")
      let start_skip = strpart(start_skip, 0, strlen(start_skip)-strlen("\<Right>"))
      "call s:Debug("SetUpTags","Start skip is now: ".start_skip)
    endif
    "call s:Debug("SetUpTags","Returning: \<Esc>".start_skip."v/".snip_end_tag."\<CR>".end_skip."\<C-g>")
    return "\<Esc>".start_skip."v/".snip_end_tag."\<CR>".end_skip."\<C-g>"
  endif
endfunction
" }}}
" {{{ NextHop() - Jump to the next tag if one is available
function! <SID>NextHop()
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  "call s:Debug("NextHop", "Col() is: ".col("."))
  "call s:Debug("NextHop", "Position of next match = ".match(getline("."), b:search_str))
  " First check to see if we have any tags on lines above the current one
  " If the first match is after the current cursor position or not on this
  " line...
  if match(getline("."), b:search_str) >= col(".") || match(getline("."), b:search_str) == -1
    " Perform a search to jump to the next tag
    "call s:Debug("NextHop", "Seaching for a tag")
    if search(b:search_str) != 0
      return s:SetUpTags()
    else
      " there are no more matches
      "call s:Debug("NextHop", "No more tags in the buffer")
      " Restore hlsarch and @/
      call s:RestoreSearch()
      return ''
    endif
  else
    " The match on the current line is on or before the cursor, so we need to
    " move the cursor back
    "call s:Debug("NextHop", "Moving the cursor back")
    "call s:Debug("NextHop", "Col is: ".col("."))
    "call s:Debug("NextHop", "Moving back to column: ".match(getline("."), b:search_str))
    while col(".") > match(getline("."), b:search_str) + 1
      call cursor(0,col('.')-1)
    endwhile
    "call s:Debug("NextHop", "Col is now: ".col("."))
    " Now we just set up the tag as usual
    return s:SetUpTags()
  endif
endfunction
" }}}
" {{{ RunCommand() - Execute commands stored in tags
function! s:RunCommand(command, z)
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  "call s:Debug("RunCommand", "RunCommand was passed this command: ".a:command." and this value: ".a:z)
  if a:command == ''
    return a:z
  endif
  " Save current value of 'z'
  let snip_save = @z
  let @z=a:z
  " Call the command
  execute 'let ret = '. a:command
  " Replace the value
  let @z = snip_save
  return ret
endfunction
" }}}
" {{{ MakeChanges() - Search the document making all the changes required
" This function has been factored out to allow the addition of commands in tags
function! s:MakeChanges()
  " Make all the changes
  " Change all the tags with the same name and no commands defined
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()

  if b:tag_name == ""
    "call s:Debug("MakeChanges", "Nothing to do: tag_name is empty")
    return
  endif

  let tagmatch = '\V'.snip_start_tag.b:tag_name.snip_end_tag

  "call s:Debug("MakeChanges", "Matching on this value: ".tagmatch)
  "call s:Debug("MakeChanges", "Replacing with this value: ".s:replaceVal)

  try
    "call s:Debug("MakeChanges", "Running these commands: ".join(b:command_dict[b:tag_name], "', '"))
  catch /E175/
    "call s:Debug("MakeChanges", "Could not find this key in the dict: ".b:tag_name)
  endtry

  let ind = 0
  while search(tagmatch,"w") > 0
    try
      let commandResult = s:RunCommand(b:command_dict[b:tag_name][0], s:replaceVal)
    catch /E175/
      "call s:Debug("MakeChanges", "Could not find this key in the dict: ".b:tag_name)
    endtry
    "call s:Debug("MakeChanges", "Got this result: ".commandResult)
    let lines = split(substitute(getline("."), tagmatch, commandResult, ''),'\n')
    if len(lines) > 1
      call setline(".", lines[0])
      call append(".", lines[1:])
    else
      call setline(".", lines)
    endif
    try
      unlet b:command_dict[b:tag_name][0]
    catch /E175/
      "call s:Debug("MakeChanges", "Could not find this key in the dict: ".b:tag_name)
    endtry
  endwhile
endfunction
" }}}
" {{{ ChangeVals() - Set up values for MakeChanges()
function! s:ChangeVals(changed)
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()

  if a:changed == 1
    let s:CHANGED_VAL = 1
  else
    let s:CHANGED_VAL = 0
  endif

  "call s:Debug("ChangeVals", "CHANGED_VAL: ".s:CHANGED_VAL)
  "call s:Debug("ChangeVals", "b:tag_name: ".b:tag_name)
  let elem_match = match(s:line, snip_elem_delim, s:curCurs)
  let tagstart = strridx(getline("."), snip_start_tag,s:curCurs)+strlen(snip_start_tag)

  "call s:Debug("ChangeVals", "About to access b:command_dict")
  try
    let commandToRun = b:command_dict[b:tag_name][0]
    "call s:Debug("ChangeVals", "Accessed command_dict")
    "call s:Debug("ChangeVals", "Running this command: ".commandToRun)
    unlet b:command_dict[b:tag_name][0]
    "call s:Debug("ChangeVals", "Command list is now: ".join(b:command_dict[b:tag_name], "', '"))
  catch /E175/
    "call s:Debug("ChangeVals", "Could not find this key in the dict: ".b:tag_name)
  endtry

  let commandMatch = substitute(commandToRun, '\', '\\\\', 'g')
  if s:CHANGED_VAL
    " The value has changed so we need to grab our current position back
    " to the start of the tag
    let replaceVal = strpart(getline("."), tagstart,s:curCurs-tagstart)
    "call s:Debug("ChangeVals", "User entered this value: ".replaceVal)
    let tagmatch = replaceVal
    "call s:Debug("ChangeVals", "Col is: ".col("."))
    call cursor(0,col('.')-s:StrLen(tagmatch))
    "call s:Debug("ChangeVals", "Col is: ".col("."))
  else
    " The value hasn't changed so it's just the tag name
    " without any quotes that are around it
    "call s:Debug("ChangeVals", "Tag name is: ".b:tag_name)
    let replaceVal = substitute(b:tag_name, '^"\(.*\)"$', '\1', '')
    "call s:Debug("ChangeVals", "User did not enter a value. Replacing with this value: ".replaceVal)
    let tagmatch = ''
    "call s:Debug("ChangeVals", "Col is: ".col("."))
  endif

  let tagmatch = '\V'.snip_start_tag.tagmatch.snip_end_tag
  "call s:Debug("ChangeVals", "Matching on this string: ".tagmatch)
  let tagsubstitution = s:RunCommand(commandToRun, replaceVal)
  let lines = split(substitute(getline("."), tagmatch, tagsubstitution, ""),'\n')
  if len(lines) > 1
    call setline(".", lines[0])
    call append(".", lines[1:])
  else
    call setline(".", lines)
  endif
  " We use replaceVal instead of tagsubsitution as otherwise the command
  " result will be passed to subsequent tags
  let s:replaceVal = replaceVal
  let line = line('.')
  let col = col('.')
  call s:MakeChanges()
  call cursor(line, col)
  unlet s:CHANGED_VAL
endfunction
" }}}
"{{{ SID() - Get the SID for the current script
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun
"}}}
"{{{ CheckForInTag() - Check whether we're in a tag
function! s:CheckForInTag()
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  if snip_start_tag != snip_end_tag
    " The tags are different so we can check to see whether the
    " end tag comes before a start tag
    let s:startMatch = match(s:line, '\V'.snip_start_tag, s:curCurs)
    let s:endMatch = match(s:line, '\V'.snip_end_tag, s:curCurs)

    if s:endMatch != -1 && ((s:endMatch < s:startMatch) || s:startMatch == -1)
      " End has come before start so we're in a tag.
      return 1
    else
      return 0
    endif
  else
    " Start and end tags are the same so we need do tag counting to see
    " whether we're in a tag.
    let s:count = 0
    let s:curSkip = s:curCurs
    while match(strpart(s:line,s:curSkip),snip_start_tag) != -1 
      if match(strpart(s:line,s:curSkip),snip_start_tag) == 0
        let s:curSkip = s:curSkip + 1
      else
        let s:curSkip = s:curSkip + 1 + match(strpart(s:line,s:curSkip),snip_start_tag)
      endif
      let s:count = s:count + 1
    endwhile
    if (s:count % 2) == 1
      " Odd number of tags implies we're inside a tag.
      return 1
    else
      " We're not inside a tag.
      return 0
    endif
  endif
endfunction
"}}}
" {{{ SubSpecialVars(text)
function! s:SubSpecialVars(text)
  let text = a:text
  let text = substitute(text, 'SNIP_FILE_NAME', expand('%'), 'g')
  let text = substitute(text, 'SNIP_ISO_DATE', strftime("%Y-%m-%d"), 'g')
  return text
endfunction
" }}}
" {{{ SubCommandOutput(text)
function! s:SubCommandOutput(text)
  let search = '``.\{-}``'
  let text = a:text
  while match(text, search) != -1
    let command_match = matchstr(text, search)
    "call s:Debug("SubCommandOutput", "Command found: ".command_match)
    let command = substitute(command_match, '^..\(.*\)..$', '\1', '')
    "call s:Debug("SubCommandOutput", "Command being run: ".command)
    exec 'let output = '.command
    let output = escape(output, '\')
    let text = substitute(text, '\V'.escape(command_match, '\'), output, '')
  endwhile
  let text = substitute(text, '\\`\\`\(.\{-}\)\\`\\`','``\1``','g')
  return text
endfunction
" }}}
" {{{ RemoveAndStoreCommands(text)
function! s:RemoveAndStoreCommands(text)
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()

  let text = a:text
  if !exists("b:command_dict")
    let b:command_dict = {}
  endif

  let tmp_command_dict = {}
  try
    let ind = match(text, b:search_str)
  catch /E55: Unmatched \\)/
    call confirm("SnippetsEmu has caught an error while performing a search. This is most likely caused by setting the start and end tags to special characters. Try setting the 'fileencoding' of the file in which you defined them to 'utf-8'.\n\nThe plugin will be disabled for the remainder of this Vim session.")
    let s:Disable = 1
    return ''
  endtry
  while ind > -1
    "call s:Debug("RemoveAndStoreCommands", "Text is: ".text)
    "call s:Debug("RemoveAndStoreCommands", "index is: ".ind)
    let tag = matchstr(text, b:search_str, ind)
    "call s:Debug("RemoveAndStoreCommands", "Tag is: ".tag)
    let commandToRun = matchstr(tag, snip_elem_delim.".*".snip_end_tag)

    if commandToRun != ''
      let tag_name = strpart(tag,strlen(snip_start_tag),match(tag,snip_elem_delim)-strlen(snip_start_tag))
      "call s:Debug("RemoveAndStoreCommands", "Got this tag: ".tag_name)
      "call s:Debug("RemoveAndStoreCommands", "Adding this command: ".commandToRun)
      if tag_name != ''
        if has_key(tmp_command_dict, tag_name)
          call add(tmp_command_dict[tag_name], strpart(commandToRun, 1, strlen(commandToRun)-strlen(snip_end_tag)-1))
        else
          let tmp_command_dict[tag_name] = [strpart(commandToRun, 1, strlen(commandToRun)-strlen(snip_end_tag)-1)]
        endif
      endif
      let text = substitute(text, '\V'.escape(commandToRun,'\'), snip_end_tag,'')
    else
      let tag_name = s:ChopTags(tag)
      if tag_name != ''
        if has_key(tmp_command_dict, tag_name)
          call add(tmp_command_dict[tag_name], '')
        else
          let tmp_command_dict[tag_name] = ['']
        endif
      endif
    endif
    "call s:Debug("RemoveAndStoreCommands", "".tag." found at ".ind)
    let ind = match(text, b:search_str, ind+strlen(snip_end_tag))
  endwhile

  for key in keys(tmp_command_dict)
    if has_key(b:command_dict, key)
      for item in reverse(tmp_command_dict[key])
        call insert(b:command_dict[key], item)
      endfor
    else
      let b:command_dict[key] = tmp_command_dict[key]
    endif
  endfor
  return text
endfunction
" }}}
" {{{ ReturnKey() - Return our mapped key or Supertab key
function! s:ReturnKey()
  if s:supInstalled
    "call s:Debug('ReturnKey', 'Snippy: SuperTab installed. Returning <C-n> instead of <Tab>')
    return "\<C-R>=".s:SupSNR."SuperTab('n')\<CR>"
  else
    " We need this hacky line as the one below doesn't seem to work.
    " Patches welcome
    exe "return \"".substitute(g:snippetsEmu_key, '^<', "\\\\<","")."\""
    "return substitute(g:snippetsEmu_key, '^<', "\\<","")
  endif
endfunction
" }}}
" {{{ Jumper()
" We need to rewrite this function to reflect the new behaviour. Every jump
" will now delete the markers so we need to allow for the following conditions
" 1. Empty tags e.g. "<{}>".  When we land inside then we delete the tags.
"  "<{:}>" is now an invalid tag (use "<{}>" instead) so we don't need to check for
"  this
" 2. Tag with variable name.  Save the variable name for the next jump.
" 3. Tag with command. Tags no longer have default values. Everything after the
" centre delimiter until the end tag is assumed to be a command.
" 
" Jumper is performed when we want to perform a jump.  If we've landed in a
" 1. style tag then we'll be in free form text and just want to jump to the
" next tag.  If we're in a 2. or 3. style tag then we need to look for whether
" the value has changed and make all the replacements.   If we're in a 3.
" style tag then we need to replace all the occurrences with their command
" modified values.
" 
function! <SID>Jumper()
  if s:Disable == 1
    return substitute(g:snippetsEmu_key, '^<', "\\<",'')
  endif
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()

  " Set up some mapping in case we got called before Supertab
  if s:supInstalled == 1 && s:done_remap != 1
    call s:SetupSupertab()
    call s:SnipMapKeys()
  endif

  if !exists('b:search_str') && exists('g:search_str')
      let b:search_str = g:search_str
  endif
   
  if !exists('b:search_str')
    return s:ReturnKey()
  endif

  let s:curCurs = col(".") - 1
  let s:curLine = line(".")
  let s:line = getline(".")
  let s:replaceVal = ""
   
  " First we'll check that the user hasn't just typed a snippet to expand
  let origword = matchstr(strpart(getline("."), 0, s:curCurs), '\(^\|\s\)\S\{-}$')
  let origword = substitute(origword, '\s', "", "")
  "call s:Debug("Jumper", "Original word was: ".origword)
  let word = s:Hash(origword)
  " The following code is lifted from the imaps.vim script - Many
  " thanks for the inspiration to add the TextMate compatibility
  let rhs = ''
  let found = 0
  " Check for buffer specific expansions
  if exists('b:trigger_'.word)
    exe 'let rhs = b:trigger_'.word
    let found = 1
  elseif exists('g:trigger_'.word)
  " also check for global definitions
    exe 'let rhs = g:trigger_'.word
    let found = 1
  endif

  if found == 0
    " Check using keyword boundary
    let origword = matchstr(strpart(getline("."), 0, s:curCurs), '\k\{-}$')
    "call s:Debug("Jumper", "Original word was: ".origword)
    let word = s:Hash(origword)
    if exists('b:trigger_'.word)
      exe 'let rhs = b:trigger_'.word
    elseif exists('g:trigger_'.word)
    " also check for global definitions
      exe 'let rhs = g:trigger_'.word
    endif
  endif

  if rhs != ''
    " Save the value of hlsearch
    if &hls
      "call s:Debug("Jumper", "Hlsearch set")
      setlocal nohlsearch
      let b:hl_on = 1
    else
      "call s:Debug("Jumper", "Hlsearch not set")
      let b:hl_on = 0
    endif
    " Save the last search value
    let b:search_sav = @/
    " Count the number of lines in the rhs
    let move_up = ""
    if len(split(rhs, "\<CR>")) - 1 != 0
      let move_up = len(split(rhs, "\<CR>")) - 1
      let move_up = move_up."\<Up>"
    endif

    " If this is a mapping, then erase the previous part of the map
    " by returning a number of backspaces.
    let bkspc = substitute(origword, '.', "\<BS>", "g")
    "call s:Debug("Jumper", "Backspacing ".s:StrLen(origword)." characters")
    let delEndTag = ""
    if s:CheckForInTag()
      "call s:Debug("Jumper", "We're doing a nested tag")
      "call s:Debug("Jumper", "B:tag_name: ".b:tag_name)
      if b:tag_name != ''
        try
          "call s:Debug("Jumper", "Commands for this tag are currently: ".join(b:command_dict[b:tag_name],"', '"))
          "call s:Debug("Jumper", "Removing command for '".b:tag_name."'")
          unlet b:command_dict[b:tag_name][0]
          "call s:Debug("Jumper", "Commands for this tag are now: ".join(b:command_dict[b:tag_name],"', '"))
        catch /E175/
          "call s:Debug("Jumper", "Could not find this key in the dict: ".b:tag_name)
        endtry
      endif
      "call s:Debug("Jumper", "Deleting start tag")
      let bkspc = bkspc.substitute(snip_start_tag, '.', "\<BS>", "g")
      "call s:Debug("Jumper", "Deleting end tag")
      let delEndTag = substitute(snip_end_tag, '.', "\<Del>", "g")
      "call s:Debug("Jumper", "Deleting ".s:StrLen(delEndTag)." characters")
    endif
    
    " We've found a mapping so we'll substitute special variables
    let rhs = s:SubSpecialVars(rhs)
    let rhs = s:SubCommandOutput(rhs)
    " Now we'll chop out the commands from tags
    let rhs = s:RemoveAndStoreCommands(rhs)
    if s:Disable == 1
      return substitute(g:snippetsEmu_key, '^<', "\\<",'')
    endif

    " Save the value of 'backspace'
    let bs_save = &backspace
    set backspace=indent,eol,start
    return bkspc.delEndTag.rhs."\<Esc>".move_up."^:set backspace=".bs_save."\<CR>a\<C-r>=<SNR>".s:SID()."_NextHop()\<CR>"
  else
    " No definition so let's check to see whether we're in a tag
    if s:CheckForInTag()
      "call s:Debug("Jumper", "No mapping and we're in a tag")
      " We're in a tag so we need to do processing
      if strpart(s:line, s:curCurs - strlen(snip_start_tag), strlen(snip_start_tag)) == snip_start_tag
        "call s:Debug("Jumper", "Value not changed")
        call s:ChangeVals(0)
      else
        "call s:Debug("Jumper", "Value changed")
        call s:ChangeVals(1)
      endif
      return "\<C-r>=<SNR>".s:SID()."_NextHop()\<CR>"
    else
      " We're not in a tag so we'll see whether there are more tags
      if search(b:search_str, "n")
        " More tags so let's perform nexthop
        let s:replaceVal = ""
        return "\<C-r>=<SNR>".s:SID()."_NextHop()\<CR>"
      else
        " No more tags so let's return a Tab after restoring hlsearch and @/
        call s:RestoreSearch()
        if exists("b:command_dict")
          unlet b:command_dict
        endif
        return s:ReturnKey()
      endif
    endif
  endif
endfunction
" }}}
"{{{ ListSnippets() - Return a list of snippets - used for command completion
function! s:ListSnippets(ArgLead, CmdLine, CursorPos, scope)
  " Only allow completion for the second argument
  " TODO
    return sort(map(map(filter(keys(a:scope), 'v:val =~ "^trigger_'.a:ArgLead.'"'), 'v:val[8:]'), 's:UnHash(v:val)'))
endfunction

function! s:ListBufferSnippets(ArgLead, CmdLine, CursorPos)
  return s:ListSnippets(a:ArgLead, a:CmdLine, a:CursorPos, b:)
endfunction

function! s:ListGlobalSnippets(ArgLead, CmdLine, CursorPos)
  return s:ListSnippets(a:ArgLead, a:CmdLine, a:CursorPos, g:)
endfunction
" }}}
" {{{ DelSnippet() - Delete a snippet
function! s:DelSnippet(snippet, scope)
  if a:snippet != ""
    try
      exec "unlet ".a:scope."trigger_".s:Hash(a:snippet)
    catch /E108: No such variable:/
      echom "Snippet '".a:snippet."' does not exist."
    endtry
  endif
endfunction
" }}}
" {{{ Set up the 'Iabbr' and 'Snippet' commands
"command! -nargs=+ Iabbr execute s:SetCom(<q-args>)
"command! -nargs=+ Snippet execute s:SetCom("<buffer> ".<q-args>)
command! -complete=customlist,s:ListGlobalSnippets -nargs=*
         \ Iabbr call <SID>SetCom(<q-args>, "g:")
command! -complete=customlist,s:ListBufferSnippets -nargs=*
         \ Snippet call <SID>SetCom(<q-args>, "b:")
command! -range CreateSnippet <line1>,<line2>call s:CreateSnippet()
command! -range CreateBundleSnippet <line1>,<line2>call s:CreateBundleSnippet()
command! -complete=customlist,s:ListBufferSnippets -nargs=*
      \ DelSnippet call <SID>DelSnippet(<q-args>, "b:")
command! -complete=customlist,s:ListGlobalSnippets -nargs=*
      \ DelIabbr call <SID>DelSnippet(<q-args>, "g:")
"}}}
" {{{ Utility functions

" This function will convert the selected range into a snippet
function! s:CreateSnippet() range
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  let snip = ""
  if &expandtab
      let tabs = indent(a:firstline)/&shiftwidth
      let tabstr = repeat(' ',&shiftwidth)
  else
      let tabs = indent(a:firstline)/&tabstop
      let tabstr = '\t'
  endif
  let tab_text = repeat(tabstr,tabs)

  for i in range(a:firstline, a:lastline)
    "First chop off the indent
    let text = substitute(getline(i),tab_text,'','')
    "Now replace 'tabs' with <Tab>s
    let text = substitute(text, tabstr, '<Tab>','g')
    "And trim the newlines
    let text = substitute(text, "\r", '','g')
    let snip = snip.text.'<CR>'
  endfor
  let tag = snip_start_tag.snip_end_tag
  let split_sav = &swb
  set swb=useopen
  if bufexists("Snippets")
    belowright sb Snippets
  else
    belowright sp Snippets
  endif
  resize 8
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  let @"=tag
  exe 'set swb='.split_sav
  let trig = inputdialog("Please enter the trigger word for your snippet: ", "My_snippet")
  if trig == ""
    let trig = "YOUR_SNIPPET_NAME_HERE"
  endif
  call append("$", "Snippet ".trig." ".snip)
  if getline(1) == ""
    1 delete _
  endif
  call cursor(line('$'),1)
endfunction

" This function will convert the selected range into a snippet suitable for
" including in a bundle.
function! s:CreateBundleSnippet() range
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  let snip = ""
  if &expandtab
      let tabs = indent(a:firstline)/&shiftwidth
      let tabstr = repeat(' ',&shiftwidth)
  else
      let tabs = indent(a:firstline)/&tabstop
      let tabstr = '\t'
  endif
  let tab_text = repeat(tabstr,tabs)

  for i in range(a:firstline, a:lastline)
    let text = substitute(getline(i),tab_text,'','')
    let text = substitute(text, tabstr, '<Tab>','g')
    let text = substitute(text, "\r$", '','g')
    let text = substitute(text, '"', '\\"','g')
    let text = substitute(text, '|', '<Bar>','g')
    let snip = snip.text.'<CR>'
  endfor
  let tag = '".st.et."'
  let split_sav = &swb
  set swb=useopen
  if bufexists("Snippets")
    belowright sb Snippets
  else
    belowright sp Snippets
  endif
  resize 8
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  let @"=tag
  exe 'set swb='.split_sav
  let trig = inputdialog("Please enter the trigger word for your snippet: ", "My_snippet")
  if trig == ""
    let trig = "YOUR_SNIPPET_NAME_HERE"
  endif
  call append("$", 'exe "Snippet '.trig." ".snip.'"')
  if getline(1) == ""
    1 delete _
  endif
  call cursor(line('$'),1)
endfunction

" This function will just return what's passed to it unless a change has been
" made
fun! D(text)
  if exists('s:CHANGED_VAL') && s:CHANGED_VAL == 1
    return @z
  else
    return a:text
  endif
endfun

" s:Hash allows the use of special characters in snippets
" This function is lifted straight from the imaps.vim plugin. Please let me know
" if this is against licensing.
function! s:Hash(text)
	return substitute(a:text, '\([^[:alnum:]]\)',
				\ '\="_".char2nr(submatch(1))."_"', 'g')
endfunction

" s:UnHash allows the use of special characters in snippets
" This function is lifted straight from the imaps.vim plugin. Please let me know
" if this is against licensing.
function! s:UnHash(text)
	return substitute(a:text, '_\(\d\+\)_',
				\ '\=nr2char(submatch(1))', 'g')
endfunction

" This function chops tags from any text passed to it
function! s:ChopTags(text)
  let text = a:text
  "call s:Debug("ChopTags", "ChopTags was passed this text: ".text)
  let [snip_start_tag, snip_elem_delim, snip_end_tag] = s:SetLocalTagVars()
  let text = strpart(text, strlen(snip_start_tag))
  let text = strpart(text, 0, strlen(text)-strlen(snip_end_tag))
  "call s:Debug("ChopTags", "ChopTags is returning this text: ".text)
  return text
endfunction

" This function ensures we measure string lengths correctly
function! s:StrLen(str)
  "call s:Debug("StrLen", "StrLen returned: ".strlen(substitute(a:str, '.', 'x', 'g'))." based on this text: ".a:str)
  return strlen(substitute(a:str, '.', 'x', 'g'))
endfunction

" }}}
" vim: set tw=80 sw=2 sts=2 et foldmethod=marker :
