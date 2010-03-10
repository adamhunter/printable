
require 'prawn'

# usage: 
# class MyModel
#   acts_as_printable
# end
# 
# MyModel.new.to_pdf
# will print using mymodel.print 
module Printable
  
  # the <tt>:command_path</tt> should always end in a slash so
  # that if set to nil it will resolve to just <tt>`pdftk`</tt>
  def self.options
    @@options ||= {
      :command_path   => '/usr/local/bin/',
      :command_logger => '/dev/null 2>&1'
    }
  end
  
end

require 'printable/printer'
require 'printable/instance_methods'