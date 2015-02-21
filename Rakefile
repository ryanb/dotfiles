require 'rake'
require 'erb'
require 'fileutils'
require_relative 'dotfiles'

desc "install the dot files into user's home directory"
task :install do
  prerequisites

  install_oh_my_zsh
  switch_to_zsh

  install_janus
  install_vim_plugins

  Dotfiles.new.install
end

task :uninstall do
  Dotfiles.new.uninstall
end

def prerequisites
  puts '-----------------------------------------------------------------------'
  puts 'this will install oh-my-zsh, janus, a bunch of vim plugins'
  puts 'and some dotfiles'
  puts ''
  puts 'please make sure before continuing that the prerequisites are met'
  puts ' - git'
  puts ' - curl'
  puts ' - vim (with ruby support)'
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

def install_janus
  print "install janus? [ynq] "
  case $stdin.gets.chomp
  when 'y'
    puts "installing janus"
    system %Q{curl -Lo- https://bit.ly/janus-bootstrap | bash}
  when 'q'
    exit
  else
    puts "skipping janus"
  end
end

def install_vim_plugins
  print "install additional vim plugins (highly recommended)? [ynq] "
  case $stdin.gets.chomp
  when 'y'
    puts "installing vim plugins"
    dir = File.join(Dir.home, '.janus')
    FileUtils.mkdir_p(dir)

    puts "installing additional vim plugins"
    system %Q{git clone https://github.com/vim-scripts/fontzoom.vim "#{File.join(dir, 'fontzoom.vim')}"}
    system %Q{git clone https://github.com/vim-scripts/vcscommand.vim "#{File.join(dir, 'vcscommand.vim')}"}
    system %Q{git clone https://github.com/vim-scripts/vrackets "#{File.join(dir, 'vrackets')}"}
    system %Q{git clone https://github.com/vim-scripts/L9.git "#{File.join(dir, 'L9')}"}
    system %Q{git clone https://github.com/vim-scripts/FuzzyFinder.git "#{File.join(dir, 'FuzzyFinder')}"}
    system %Q{git clone https://github.com/mattn/emmet-vim.git "#{File.join(dir, 'emmet-vim')}"}
    system %Q{git clone https://github.com/digitaltoad/vim-jade.git "#{File.join(dir, 'vim-jade')}"}
    system %Q{git clone https://github.com/jeffkreeftmeijer/vim-numbertoggle.git "#{File.join(dir, 'vim-numbertoggle')}"}
    system %Q{git clone https://github.com/terryma/vim-smooth-scroll.git "#{File.join(dir, 'vim-smooth-scroll')}"}
  when 'q'
    exit
  else
    puts "skipping vim plugins"
  end
end
