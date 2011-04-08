# postconditional <leader>rcpc
somethign if condition

# inlinetemp <leader>rit
foo = 10
puts foo

# addparameter <leader>rap
def thingy(dependency)
  stuff
end

# extract constant <leader>rec
class Thing
  def method_one
    10
  end
end

# extract local variable <leader>relv
class Thing
  def method_one
    10
  end
end

# rename local variable <leader>rrlv
def method
  asdf = 10
end

# rename instance variable <leader>rriv
class Foo
  def method_one
    @bar = foo
  end

  def method_two
    @bar = bar
  end
end

# extract method <leader>rem
class Foo
  def method_one
    @bar = foo
  end

  def method_two
    one = 1
    two = 2
    three = 3
    four = two + two
    five = two + three
    six = five + one
  end
end

describe "something" do
  it 'is a foo in the bar' do
    bar = '13'
    far.should be_foo
  end
end
