require 'reruby/better_buffer'
require 'support/fake_buffer'

module Reruby
  describe BetterBuffer do

    let(:vim_buffer) { FakeBuffer.new(%w{a b c d}) }
    subject          { BetterBuffer.new(vim_buffer) }

    describe ".[]" do
      it "returns a single line" do
        subject[2].should == "b"
      end

      it "returns a range of lines" do
        subject[2..3].should == %w{b c}
      end
    end

    describe ".[]=" do
      it "replaces a single line" do
        subject[2] = "q"
        vim_buffer.lines.should == %w{a q c d}
      end

      it "replaces multiple lines" do
        subject[2..3] = %w{q r s}
        vim_buffer.lines.should == %w{a q r s d}
      end
    end

    describe ".delete" do
      it "deletes a single line" do
        subject.delete(2)
        vim_buffer.lines.should == %w{a c d}
      end

      it "deletes multiple lines" do
        subject.delete(2..3)
        vim_buffer.lines.should == %w{a d}
      end
    end

    describe ".append" do
      it "appends a single line" do
        subject.append(1, "q")
        vim_buffer.lines.should == %w{a q b c d}
      end

      it "appends multiple lines" do
        subject.append(1, ["q", "r"])
        vim_buffer.lines.should == %w{a q r b c d}
      end
    end

  end
end
