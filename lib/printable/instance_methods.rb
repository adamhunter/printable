module Printable
  module InstanceMethods
    
    def print(path = nil)
      path ||= File.join(File.dirname(__FILE__), "#{self.class.name.downcase}.print")
      Printable::Printer.new(self, path).print
    end
    
  end
end

def acts_as_printable(options = {})
  Printable.options.merge!(options)
  include Printable::InstanceMethods
end