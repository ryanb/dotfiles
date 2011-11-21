require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.rdoc LICENSE].include? file
    dest = File.join(ENV['HOME'], ".#{file.sub('.erb', '')}")
    
    if File.exist?(dest)
      if file =~ /.erb$/
        content = File.read(file)
        if !content.include?('STDIN') and !content.include?('$stdin')
          system %Q{mkdir -p tmp}
          generate_file(file, File.join('tmp', file.sub('.erb', '')), false)
        end
      end
      
      if File.identical? file, dest
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        system %{diff #{file} ~/.#{file.sub('.erb', '')}} if verbose
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

def current_or_prompt(path, prompt)
  current = yield path
  if @interactive
    current ||= ""
    print(prompt)
    print(" [#{current}]") unless current.empty?
    print(": ")
    STDOUT.flush
    value = STDIN.gets.chomp
    value = current if value.empty? and !current.empty?
    value
  elsif current.empty?
    "<<< no value as of #{Time.now} >>>"
  else
    return current
  end
end

def generate_file(file, dest, interactive=true)
  @interactive = interactive
  File.open(dest, 'w') do |new_file|
    new_file.write ERB.new(File.read(file)).result(binding)
  end
  dest
end

def replace_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    generate_file(file, File.join('tmp', "#{file.sub('.erb', '')}"))
  end
  
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    generated_file = file.sub('.erb', '')
    system %Q{cp tmp/#{generated_file} $HOME/.#{generated_file}}
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end
