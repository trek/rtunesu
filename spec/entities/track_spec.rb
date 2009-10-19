require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe Track do
  before(:each) do
    @klass = Track
    @entity = Track.new
    @track = @entity
    @attributes = {:name => 'Sample Lecture'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
end