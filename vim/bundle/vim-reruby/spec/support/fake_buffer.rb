# This class mimics the API of the VIM::Buffer class, for testing.
class FakeBuffer
  def initialize(contents)
    @lines = case contents
      when String
        contents.split("\n")
      when Array
        contents
    end
  end

  attr_reader :lines

  def to_s
    @lines.join("\n") + "\n"
  end

  # Methods provided by VIM::Buffer:

  def [](n)
    @lines[n - 1]
  end

  def []=(n, line)
    @lines[n - 1] = line
  end

  def delete(n)
    @lines.delete_at(n - 1)
  end

  def append(n, str)
    @lines.insert(n, str)
  end

end
