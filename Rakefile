require 'rake'
require 'erb'
require 'fileutils'
require_relative 'dotfiles'

desc "install the dot files into user's home directory"
task :install do
  install_oh_my_zsh
  switch_to_zsh

  install_janus
  install_vim_plugins

  Dotfiles.new.install
end

task :uninstall do
  Dotfiles.new.uninstall
end

def switch_to_zsh
  if ENV["SHELL"] =~ /zsh/
    puts "using zsh"
  else
    print "switch to zsh? (recommended) [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "switching to zsh"
      system %Q{chsh -s `which zsh`}
    when 'q'
      exit
    else
      puts "skipping zsh"
    end
  end
end

def install_oh_my_zsh
  if File.exist?(File.join(ENV['HOME'], ".oh-my-zsh"))
    puts "found ~/.oh-my-zsh"
  else
    print "install oh-my-zsh? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "installing oh-my-zsh"
      system %Q{git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"}
    when 'q'
      exit
    else
      puts "skipping oh-my-zsh, you will need to change ~/.zshrc"
    end
  end
end

def install_janus
  puts "installing janus"
  system %Q{curl -Lo- https://bit.ly/janus-bootstrap | bash}
end

def install_vim_plugins
  dir = File.join(Dir.home, '.janus')
  FileUtils.mkdir_p(dir)
  Dir.chdir(dir)

  puts "installing additional vim plugins"
  system %Q{git clone https://github.com/vim-scripts/fontzoom.vim}
  system %Q{git clone git@github.com:dbldots/frett.vim.git}
  system %Q{git clone git://github.com/vim-scripts/vcscommand.vim.git}
  system %Q{git clone https://github.com/jistr/vim-nerdtree-tabs.git}
  system %Q{git clone git@github.com:vim-scripts/vrackets.git}
end
