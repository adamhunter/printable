require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Printable::InstanceMethods do
  
  it "should include the Receipt module" do
    Example.ancestors.should include(Printable::InstanceMethods)
  end
  
  it "should add the print method onto new instances of the object" do
    Example.new.should respond_to(:print)
  end
  
  it "should add a printer onto new instances of the object" do
    Example.new.printer(nil).should be_a(Printable::Printer)
  end
  
  it "should call print on the Receipt::Printer" do
    Printable::Printer.stub!(:new).and_return(@mock = mock(:print => true))
    @mock.should_receive(:print)
    Example.new.print
  end
  
end