require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Printable do
  
  it "should have options" do
    Printable.options.should be_a(Hash)
  end
  
  it "should allow its options to be changed" do
    Printable.options[:command_path] = 'other/path'
    Printable.options[:command_path].should == 'other/path'
  end
  
end