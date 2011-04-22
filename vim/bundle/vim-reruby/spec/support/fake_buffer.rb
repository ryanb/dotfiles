class FakeBuffer
  def initialize(contents)
    @lines = contents.split("\n")
  end

  def [](n)
    @lines[n - 1]
  end

  def delete(n)
    @lines.delete_at(n - 1)
  end

  def append(n, str)
    @lines.insert(n, str)
  end

  def to_s
    @lines.join("\n") + "\n"
  end
end
