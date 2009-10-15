begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'spec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rtunesu'

def xml(name)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', name))
end