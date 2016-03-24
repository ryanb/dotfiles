require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  install_config_files
  install_fonts
  install_homebrew
  install_packages
  configure_vim
  configure_git
  configure_osx
end


def install_config_files
  puts '*** Config files ***'

  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE fonts].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical? file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def install_fonts
  puts
  puts '*** Fonts ***'

  system("/bin/sh", "-c", <<-EOF)
    cp fonts/Inconsolata.otf $HOME/Library/Fonts
  EOF
end

def install_homebrew
  puts
  puts '*** Homebrew *** '

  system("/bin/sh", "-c", <<-EOF)
    if which brew > /dev/null; then
      echo 'brew is already installed.'
    else
      echo 'Installing brew...'
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
  EOF
end

def install_packages
  puts
  puts '*** Packages *** '

  system("/bin/sh", "-c", <<-EOF)
    brew_install () {
      if brew list | grep $1 > /dev/null; then
        echo "$1 is already installed."
      else
        echo "Installing $1..."
        brew install $1
      fi
    }

    brew_install git
    brew_install gh

    brew_install tmux

    brew_install chruby
    brew_install ruby-install
    ruby_version=`cat ~/.ruby-version`
    if [ ! -d ~/.rubies/ruby-$ruby_version ]; then
      ruby-install ruby $ruby-version
      gem install bundler
    else
      echo 'Ruby 2.3.0 is already installed.'
    fi

    brew_install vim
    brew_install ctags

    brew_install nodenv
    node_version=`cat ~/.node-version`
    if [ ! -d ~/.nodenv/versions/$node_version ]; then
      nodenv install $node_version
      npm install npm -g
      npm install standard -g
      npm install babel-eslint -g
      nodenv rehash
    else
      echo 'Node 4.2.6 is already installed.'
    fi

    brew_install the_silver_searcher
  EOF
end

# Set up Vundle.
def configure_vim
  puts
  puts '*** Vim config *** '

  system("/bin/sh", "-c", <<-EOF)
    mkdir -p ~/.vim/bundle
    if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
      git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim -u ~/.vundle +PluginInstall +qall
  EOF
end

def configure_git
  puts
  puts '*** Git config *** '

  system("/bin/sh", "-c", <<-EOF)
    git config --global user.name "Pete Yandell"
    git config --global user.email "pete@notahat.com"
    git config --global github.user notahat
    git config --global difftool.prompt false
    git config --global color.ui true
    git config --global core.excludesfile '~/.gitignore'

    # Make git push only push the current branch.
    git config --global push.default current

    # Make new branches do a rebase on git pull.
    git config --global branch.autosetuprebase always
    git config --global merge.defaultToUpstream true

    # Helpful aliases.
    git config --global alias.root '!pwd'
    git config --global alias.build '!git push -f origin HEAD:build/notahat/$(openssl rand -hex 3)'
    git config --global alias.build-without-master '!git push -f origin HEAD:build/notahat/$(openssl rand -hex 3)-without-master'
    git config --global alias.build-specs '!git push -f origin HEAD:build-specs/notahat/$(openssl rand -hex 3)'
    git config --global alias.build-specs-without-master '!git push -f origin HEAD:build-specs/notahat/$(openssl rand -hex 3)-without-master'
    git config --global alias.build-features '!git push -f origin HEAD:build-features/notahat/$(openssl rand -hex 3)'
    git config --global alias.build-features-without-master '!git push -f origin HEAD:build-features/notahat/$(openssl rand -hex 3)-without-master'
    git config --global alias.build-js '!git push -f origin HEAD:build-js/notahat/$(openssl rand -hex 3)'
    git config --global alias.build-js-without-master '!git push -f origin HEAD:build-js/notahat/$(openssl rand -hex 3)-without-master'
  EOF
end

def configure_osx
  puts
  puts '*** OS X config *** '

  system("/bin/sh", "-c", <<-EOF)
    # Disable the dashboard.
    defaults write com.apple.dashboard mcx-disabled -boolean YES

    # Clear out the dock.
    defaults write com.apple.dock checked-for-launchpad -boolean YES
    defaults write com.apple.dock persistent-apps "()"
    defaults write com.apple.dock orientation left

    killall Dock

    # Set up menu bar extras.
    defaults write com.apple.systemuiserver menuExtras -array \
      "/System/Library/CoreServices/Menu Extras/Battery.menu" \
      "/System/Library/CoreServices/Menu Extras/Clock.menu"

    killall SystemUIServer
  EOF
end
