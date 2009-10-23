require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe Section do
  before(:each) do
    @klass = Section
    @entity = Section.new
    @section = @entity
    @attributes = {:name => 'Sample Course'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  it_should_behave_like "a findable Entity"
  it_should_behave_like "a creatable Entity"
  
    
  it_should_be_composed_of :name
  it_should_have_many :courses
end