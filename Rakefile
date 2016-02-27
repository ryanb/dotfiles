require 'rake'
require 'erb'
require 'fileutils'
require_relative 'dotfiles'

desc "install the dot files into user's home directory"
task :install do
  prerequisites

  install_oh_my_zsh
  install_neobundle
  install_spacemacs

  Dotfiles.new.install

  puts '-----------------------------------------------------------------------'
  puts 'done.'
end

task :uninstall do
  Dotfiles.new.uninstall
end

def prerequisites
  puts '-----------------------------------------------------------------------'
  puts 'this will install oh-my-zsh, install and configure neovim and spacemacs,'
  puts 'and some more dotfiles'
  puts ''
  puts 'please make sure before continuing that the prerequisites are met'
  puts ' - git'
  puts ''
  puts 'these tools you need in order to use the configurations (post-requisites)'
  puts ' - neovim'
  puts ' - zsh'
  puts ' - chruby'
  puts ' - ctags'
  puts ' - silversearcher-ag'
  puts ' - emacs (>= 24)'
  puts ''
  print "do you want to proceed? [yn] "
  case $stdin.gets.chomp
  when 'n'
    exit
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

def install_neobundle
  if File.exist?(File.join(ENV['HOME'], ".config/nvim/bundle"))
    puts "found ~/.config/nvim/bundle/neobundle.vim"
  else
    print "install neobundle? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "installing neobundle"
      system %Q{mkdir -p "$HOME/.config"}
      system %Q{git clone https://github.com/Shougo/neobundle.vim "$HOME/.config/nvim/bundle/neobundle.vim"}
      puts "Neobundle installed! Please run :NeoBundleInstall from inside neovim to install all the plugins."
    when 'q'
      exit
    else
      puts "skipping neobundle"
    end
  end
end

def install_spacemacs
  if File.exist?(File.join(ENV['HOME'], ".emacs.d"))
    puts "found ~/.emacs.d"
  else
    print "install spacemacs? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "installing spacemacs"
      system %Q{git clone https://github.com/syl20bnr/spacemacs "$HOME/.emacs.d"}
      puts "Spacemacs installed!"
    when 'q'
      exit
    else
      puts "skipping spacemacs"
    end
  end
end
