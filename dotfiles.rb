class Dotfiles
  require 'fileutils'

  def initialize
    @pwd = FileUtils.pwd
    @home = ENV['HOME']
    @overwrite_all = false
    @delete_all = false
  end

  def install
    Dir.glob(File.join(@pwd, 'files/**/*')).each { |file| create(file) }
  end

  def uninstall
    Dir.glob(File.join(@pwd, 'files/**/*')).each { |file| remove(file) }
  end

  def create(file)
    return if File.directory?(file)

    destination = new_path(file)

    if !File.exist?(destination)
      write(file, destination)
    else
      if File.identical?(file, destination)
        puts "identical #{destination}"
      elsif @overwrite_all
        write(file, destination)
      else
        print "overwrite #{destination}? [ynaq] "
        overwrite = case $stdin.gets.chomp
          when 'a'
            @overwrite_all = true
            true
          when 'y'
            true
          when 'q'
            exit
          end

        overwrite ? write(file, destination) : puts("skipping #{destination}")
      end
    end
  end

  def write(source, destination)
    FileUtils.mkdir_p(File.dirname(destination))
    File.unlink(destination) if File.exist?(destination)

    if source =~ /.erb$/
      puts "generating #{destination}"
      File.open(destination, 'w') do |new_file|
        new_file.write ERB.new(File.read(source)).result(binding)
      end
    #elsif source =~ /zshrc$/ # copy zshrc instead of link
      #puts "copying #{destination}"
      #FileUtils.cp(source, destination)
    else
      puts "linking #{destination}"
      FileUtils.ln_s(source, destination)
    end
  end

  def remove(file)
    destination = new_path(file)
    return unless File.exist?(destination)

    print "delete #{destination}? [ynaq] "
    delete = case $stdin.gets.chomp
      when 'a'
        @delete_all = true
        true
      when 'y'
        true
      when 'q'
        exit
      end

    if delete || @delete_all
      File.unlink(destination)

      # attempt to delete directory
      # fails if not empty
      Dir.unlink(File.dirname(destination)) rescue nil
    end
  end

  def new_path(file)
    basename = File.basename(file)
    basename.gsub!('.erb', '')
    basename[0] = '.' if basename[0] == '_'

    path = File.dirname(file)
    # remove current source path
    path.gsub!(File.join(@pwd, 'files'), '') 

    # convert starting _ into .
    folders = path.split('/').each do |folder|
      folder[0] = '.' if folder[0] == '_'
    end

    File.join(@home, *folders, basename)
  end
end
