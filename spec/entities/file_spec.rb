require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe RTunesU::File do  
  before(:each) do
    @klass = RTunesU::File
    @entity = RTunesU::File.new
    @file = @entity
    @attributes = {:name => 'foo.png'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  
  it_should_be_composed_of :name, :path, :shared
  it_should_be_composed_of :size, :readonly => true
end