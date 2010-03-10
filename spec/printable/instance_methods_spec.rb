require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Printable::InstanceMethods do
  
  it "should include the Receipt module" do
    Example.ancestors.should include(Printable::InstanceMethods)
  end
  
  it "should add the print method onto new instances of the object" do
    Example.new.should respond_to(:print)
  end
  
  it "should call print on the Receipt::Printer" do
    Receipt::Printer.stub!(:new).and_return(@mock = mock(:print => true))
    @mock.should_receive(:print)
    Example.new.print
  end
  
end