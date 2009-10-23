require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe ExternalFeed do  
  before(:each) do
    @klass = ExternalFeed
    @entity = ExternalFeed.new
    @external_feed = @entity
    @attributes = {:owner_email => 'owner@exmaple.com'}
  end
  
  it_should_behave_like "an Entity with attribute assignment"
  it_should_be_composed_of :polling_interval, :owner_email, :security_type, :signature_type, :basic_auth_username, :basic_auth_password
  
  it "have a blank parent handle for polymorphism" do
    @external_feed.parent_handle.should_not be_nil
    @external_feed.parent_handle.should be_empty
  end
end