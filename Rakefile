require 'rake'
require 'erb'
require 'fileutils'
require_relative 'dotfiles'

desc "install the dot files into user's home directory"
task :install do
  prerequisites

  install_oh_my_zsh
  switch_to_zsh

  install_vundle

  Dotfiles.new.install
end

task :uninstall do
  Dotfiles.new.uninstall
end

def prerequisites
  puts '-----------------------------------------------------------------------'
  puts 'this will install oh-my-zsh and a bunch of (neo)vim plugins'
  puts 'and some dotfiles'
  puts ''
  puts 'please make sure before continuing that the prerequisites are met'
  puts ' - git'
  puts ' - curl'
  puts ' - neovim'
  puts ' - zsh'
  puts ' - rvm'
  puts ' - ctags'
  puts ' - ack'
  puts ' - silversearcher-ag'
  puts ''
  print "do you want to proceed? [yn] "
  case $stdin.gets.chomp
  when 'n'
    exit
  end
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

def install_vundle
  if File.exist?(File.join(ENV['HOME'], ".nvim/bundle"))
    puts "found ~/.bundle/vundle"
  else
    print "install vundle? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "installing vundle"
      system %Q{git clone https://github.com/gmarik/Vundle.vim.git "$HOME/.nvim/bundle/vundle"}
      puts "Vundle installed! Please run :PluginInstall from inside neovim to install all the plugins."
    when 'q'
      exit
    else
      puts "skipping vundle"
    end
  end
end
