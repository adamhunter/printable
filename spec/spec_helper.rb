require File.join(File.dirname(__FILE__), '..', 'lib', 'printable')
require 'spec/autorun'

require 'fixtures/example'

def file_fixture(filename)
  open(File.join(File.dirname(__FILE__), 'fixtures', "#{filename.to_s}")).read
end

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
end
