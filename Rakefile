$:.push File.join(File.dirname(__FILE__), 'lib')

require 'receipt'

task :print_example do
  require 'spec/fixtures/example'
  Example.new.print File.join(File.dirname(__FILE__), 'spec', 'fixtures', 'example.receipt')
end