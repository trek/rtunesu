require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe Permission do
  before(:each) do
    @klass = Permission
    @entity = Permission.new
    @permission = @entity
    @attributes = {:credential => 'Administrator@urn:mace:itunesu.com:sites:example.edu'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  it_should_be_composed_of  :credential, :access
  
end