require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'
include RTunesU

describe Division do
  before(:each) do
    @klass = Division
    @entity = Division.new
    @division = @entity
    @attributes = {:name => 'Sample Division'}
  end
  
  it_should_behave_like "an Entity"
    
  it_should_be_composed_of :name, :short_name, :identifier, :allow_subscription, :theme_handle, :description
  it_should_be_composed_of_readonly :aggregate_file_size
  it_should_have_many :permissions, :sections
end