#!/usr/bin/env ruby

# to install, add the following line to your .bash_profile or .bashrc
# complete -C path/to/rake_completion -o default rake

# Rake completion will return matching rake tasks given typed text. This way
# you can auto-complete tasks as you are typing them by hitting [tab] or [tab][tab]
# This also caches the rake tasks for optimium speed
class RakeCompletion
  CACHE_FILE_NAME = '.rake_tasks~'
  
  def initialize(command)
    @command = command
  end
  
  def matches
    exit 0 if rakefile.nil?
    matching_tasks.map do |task|
      task.sub(typed_before_colon, '')
    end
  end
  
  private
  
  def typed
    @command[/\s(.+?)$/, 1] || ''
  end
  
  def typed_before_colon
    typed[/.+\:/] || ''
  end
  
  def matching_tasks
    all_tasks.select do |task|
      task[0, typed.length] == typed
    end
  end
  
  def all_tasks
    cache_current? ? tasks_from_cache : generate_tasks
  end
  
  def cache_current?
    File.exist?(cache_file) && File.mtime(cache_file) >= File.mtime(rakefile)
  end
  
  def rakefile
    ['rakefile', 'Rakefile', 'rakefile.rb', 'Rakefile.rb'].detect do |file|
      File.file? File.join(Dir.pwd, file)
    end
  end
  
  def cache_file
    File.join(Dir.pwd, CACHE_FILE_NAME)
  end
  
  def tasks_from_cache
    IO.read(cache_file).split
  end
  
  def generate_tasks
    tasks = `rake --tasks`.split("\n")[1..-1].collect {|line| line.split[1]}
    File.open(cache_file, 'w') { |f| f.write tasks.join("\n") }
    tasks
  end
end

puts RakeCompletion.new(ENV["COMP_LINE"]).matches
exit 0
