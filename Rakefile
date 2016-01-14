require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  install_config_files
  install_fonts
  configure_vim
  configure_git
  configure_osx
end


def install_config_files
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
  system("/bin/sh", "-c", <<-EOF)
    cp fonts/Inconsolata.otf $HOME/Library/Fonts
  EOF
end

# Set up Vundle.
def configure_vim
  system("/bin/sh", "-c", <<-EOF)
    mkdir -p ~/.vim/bundle
    if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
      git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    fi
    vim -u ~/.vundle +PluginInstall +qall
  EOF
end

def configure_git
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
