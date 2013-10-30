require 'vimrunner'
require 'vimrunner/rspec'

Vimrunner::RSpec.configure do |config|
  config.reuse_server = true

  config.start_vim do
    vim = Vimrunner.start_gvim
    vim.prepend_runtimepath(File.expand_path('../..', __FILE__))
    vim.set 'expandtab'
    vim.set 'shiftwidth', 2
    vim
  end

  def assert_correct_indenting(string)
    whitespace = string.scan(/^\s*/).first
    string = string.split("\n").map { |line| line.gsub /^#{whitespace}/, '' }.join("\n").strip

    File.open 'test.rb', 'w' do |f|
      f.write string
    end

    vim.edit 'test.rb'
    vim.normal 'gg=G'
    vim.write

    IO.read('test.rb').strip.should eq string
  end
end
