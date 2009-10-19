require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'
include RTunesU

describe Group do
  before(:each) do
    @klass = Group
    @entity = Group.new
    @group = @entity
    @attributes = {:name => 'Sample Tab'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  it_should_behave_like "a findable Entity"
    
  it_should_be_composed_of :name, :group_type, :short_name, :allow_subscription, :explicit
  it_should_be_composed_of_readonly :aggregate_file_size
  it_should_have_many :permissions, :tracks, :shared_objects
  it_should_have_a    :external_feed
end