require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe Site do
  before(:each) do
    @klass = Site
    @entity = Site.new
    @site = @entity
    @attributes = {:name => 'Example University'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  it_should_behave_like "a findable Entity"
end