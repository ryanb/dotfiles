require 'reruby/method_extractor'
require 'support/fake_buffer'

module Reruby
  describe MethodExtractor do
    
    it "extracts a method" do
      buffer = FakeBuffer.new <<-RUBY
        def a
        end

        def b
          loop do
            puts "Hello, world!"
            puts "Goodbye, cruel world."
          end
        end
      RUBY

      MethodExtractor.new(buffer).extract_method(6..7, "foo")

      buffer.to_s.should == <<-RUBY
        def a
        end

        def foo
          puts "Hello, world!"
          puts "Goodbye, cruel world."
        end

        def b
          loop do
            foo
          end
        end
      RUBY
    end
    
  end
end
