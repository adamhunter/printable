
require 'prawn'

# usage: 
# class MyModel
#   include Receipt
# end
# 
# MyModel.new.to_pdf
# will print using mymodel.receipt 
module Receipt
  
  def print(path = nil)
    path ||= File.join(File.dirname(__FILE__), "#{self.class.name.downcase}.receipt")
    Receipt::Printer.print(self, path)
  end
  
end

def prints_receiept
  include Receipt
end

require 'receipt/printer'