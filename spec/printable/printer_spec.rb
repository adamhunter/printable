require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Printable::Printer do
  
  before :each do
    @printer = Printable::Printer.new(nil, nil)
  end
  
  it "should raise an OutOfPaper exception if the print file can't be found" do
    lambda { Printable::Printer.new(nil, 'not-a-valid-file.print') }.should raise_exception(Printable::Printer::OutOfPaper)
  end
  
  it "should not raise an exception if the path to the print file is explicitly nil" do
    lambda { Printable::Printer.new(nil, nil) }.should_not raise_exception
  end
  
  it "should read the contents of the .print file" do
    File.stub!(:read).and_return('true')
    File.should_receive(:read)
    Printable::Printer.new(nil, 'spec/fixtures/example.print')
  end
  
  it "should default to page one if not specified" do
    @printer.page :name => [1, 10]
    @printer.pages[1].should == {:name => [1, 10]}
  end
  
  it "should allow a range for background pages" do
    @printer.background 1..3, 'some-bg.pdf'
    @printer.backgrounds.keys.should == [1,2,3]
  end
  
  it "should allow an array for background pages" do
    @printer.background [1,3,5], 'some-bg.pdf'
    @printer.backgrounds.keys.sort.should == [1,3,5]
  end
  
  it "should call the method specified in the print doc to get a value when printing" do
    @example = Example.new
    @example.should_receive(:value).once
    @example.print_test_page
  end
  
  it "should call the methods in a change if the specified method is an array" do
    @example = Example.new
    @example.stub!(:memo).and_return(@memo = Memo.new)
    @memo.should_receive(:note)
    @example.print_test_page
  end
  
end