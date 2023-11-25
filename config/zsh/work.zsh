if [[ ! -v $ANDROID_HOME ]] {
  export ANDROID_HOME=$HOME/Library/Android/sdk
  export PATH=$ANDROID_HOME/emulator:$PATH
  export PATH=$ANDROID_HOME/tools:$PATH
  export PATH=$ANDROID_HOME/tools/bin:$PATH
  export PATH=$ANDROID_HOME/platform-tools:$PATH
  export PATH=$ANDROID_HOME/cmdline-tools/latest/bin:$PATH
}

if [[ ! -v $ANDROID_SDK_ROOT ]] {
  export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
  export PATH=$ANDROID_SDK_ROOT/emulator:$PATH
  export PATH=$ANDROID_SDK_ROOT/tools:$PATH
  export PATH=$ANDROID_SDK_ROOT/tools/bin:$PATH
  export PATH=$ANDROID_SDK_ROOT/platform-tools:$PATH
  export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
}

if [[ -f ~/src/up/.zsh-up-completion/init.zsh ]] {
  source ~/src/up/.zsh-up-completion/init.zsh
}
