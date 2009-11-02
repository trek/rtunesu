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
  
  it_should_behave_like "an Entity"
  
  it_should_be_composed_of :name, :group_type, :short_name, :allow_subscription, :explicit
  it_should_be_composed_of :aggregate_file_size, :readonly => true
  it_should_have_many :permissions, :tracks, :shared_objects
  it_should_have_a    :external_feed
  
  describe "external feed" do
    it "should return nil if unset" do
      @entity.external_feed.should be_nil
    end
    
    it "should return feed from XML if present" do
      id = 2628591672
      mock_connect!
      FakeWeb.register_uri(:get,
                           "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.#{id}?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                           :body => mock_upload_url_for_handle(id))
      FakeWeb.register_uri(:post, mock_upload_url_for_handle(id), :body => response_for(@klass, 'show', true))
      @entity = Group.find(id)
      @entity.external_feed.should_not be_nil
      FakeWeb.clean_registry
    end
    
    it "should return a feed if set" do
      @entity.external_feed = ExternalFeed.new
      @entity.external_feed.should_not be_nil
    end
  end
  
  describe "access rights" do
    it "should have the correct access rights as constant" do
      Group::ACCESS.should ==  {
          :no_access => "No Access",
          :steaming  => "Streaming",
          :download  => "Download",
          :drop_box  => "Drop Box",
          :shared    => "Shared",
          :edit      => "Edit"
        }
    end
  end
end