require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'
require File.dirname(__FILE__) + '/../document_spec.rb'

include RTunesU

describe Course do  
  before(:each) do
    @klass = Course
    @entity = Course.new
    @course = @entity
    @attributes = {:name => 'Sample Course'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  it_should_behave_like "a findable Entity"
  
  it_should_be_composed_of :name, :instructor, :description, :identifier, :theme_handle, :short_name, :allow_subscription
  it_should_be_composed_of_readonly :aggregate_file_size
  it_should_have_many :permissions, :groups
end