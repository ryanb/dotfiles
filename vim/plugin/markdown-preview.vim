" Defines the :Markdown command, which runs the current buffer through
" BlueCloth, and opens the result in your default browser.

" Don't try to load if we don't have Ruby support.
if !has("ruby")
  finish
endif

command! Markdown :ruby MarkdownPreview.preview

ruby <<EOF

require 'rubygems'
require 'bluecloth'
require 'pathname'

class VIM::Buffer
  include Enumerable

  def each
    (1..length).each do |line_number|
      yield(self[line_number])
    end
  end

  def contents
    to_a.join("\n")
  end

  def basename
    Pathname.new(name).basename
  end
end

module MarkdownPreview

  def self.preview
    buffer = VIM::Buffer.current

    temp_file_path = "/tmp/#{buffer.basename}.html"

    markdown = BlueCloth.new(buffer.contents)
    File.open(temp_file_path, "w") do |file|
      file << markdown.to_html
    end

    system("open #{temp_file_path}")
  end

end

EOF
