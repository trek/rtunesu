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
  
  it_should_be_composed_of :name, :kind, :disc_number, :album_name, :arist_name, :category_code, :explicit
  it_should_be_composed_of_readonly :duration_in_milliseconds, :download_url
  
  # it_should_behave_like "a creatable Entity"
  # it_should_behave_like "an updateable Entity"
  # it_should_behave_like "a deleteable Entity"
  it_should_behave_like "an Entity with attribute assignment"
  
  describe "finding" do
    before(:each) do
      mock_connect!
      FakeWeb.register_uri(:get,
                           "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.2394598528?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                           :body => mock_upload_url_for_handle(1))
      FakeWeb.register_uri(:post, mock_upload_url_for_handle(1), :body => response_for(Course, 'show', true))
    end
    
    after(:each) do
      FakeWeb.clean_registry
    end
    
    it "should be found via its course" do
      lambda { Track.find(2449134252, 2394598528) }.should_not raise_error
    end
    
    it "should have a handle" do
      Track.find(2449134252, 2394598528).handle.should_not == nil
    end
  end
end