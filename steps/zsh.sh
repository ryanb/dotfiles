link_file config/zsh/zshrc ~/.zshrc
link_file config/zsh/plugins ~/.zsh

# We use submodules for zsh plugins, so make sure we've got 'em.
git submodule update --init --depth 1
