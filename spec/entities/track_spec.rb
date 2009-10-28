require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'
require 'tempfile'
include RTunesU

describe Track do
  before(:each) do
    @klass = Track
    @entity = Track.new
    @track = @entity
    @attributes = {:name => 'Sample Lecture'}
  end
  
  it_should_be_composed_of :name, :kind, :disc_number, :track_number, :album_name, :arist_name, :category_code, :explicit, :genre_name, :comment  
  it_should_be_composed_of :duration_in_milliseconds, :download_url, :readonly => true
  it_should_have_a :remote_file 
  
  # it_should_behave_like "a creatable Entity"
  # it_should_behave_like "an updateable Entity"
  # it_should_behave_like "a deleteable Entity"
  it_should_behave_like "an Entity with attribute assignment"
  
  describe "creating" do
    before(:each) do
      @group_handle = 2628591672
      @track_handle = 2681543745
      mock_connect!
    end
    
    describe "without local file" do
      
    end
    
    describe "with local file " do
      before(:each) do
        # Fake call to create upload url for Group
        FakeWeb.register_uri(:get,
                             "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.#{@group_handle}?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302",
                             :body => mock_upload_url_for_handle(@group_handle)
                            )
        # Fake call to upload file to Group, then to upload ShowTree to group again
        FakeWeb.register_uri(:post, 
                              mock_upload_url_for_handle(@group_handle),
                              [
                               {:body => response_for(Track, 'create_with_file', true)},
                               {:body => response_for(Group, 'show', true)}
                              ]
                            )

        # Fake call to create upload url for Group, again for ShowTree on the Group
        FakeWeb.register_uri(:get,
                             "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.#{@group_handle}?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                             :body => mock_upload_url_for_handle(@group_handle)
        )
                            
        @track.parent_handle = @group_handle
        @track.file = fixture_file('sounds-of-the-cafe.mov')
      end
      
      it "should save to iTunes" do
        lambda { @track.save}.should_not raise_error
      end
      
      it "should have track meta data from iTunesU" do
        @track.save
        @track.name.should == "vidtest"
        @track.duration_in_milliseconds.should == "1000"
      end
      
      it "should raise error if attempting to update" do
        @track.instance_variable_set("@handle", 1)
        lambda { @track.save}.should raise_error
      end
    end
  end
  
  describe "finding" do
    before(:each) do
      @group_handle = 2628591672
      @track_handle = 2681543745
      mock_connect!
      FakeWeb.register_uri(:get,
                           "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.#{@group_handle}?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                           :body => mock_upload_url_for_handle(@group_handle))
      FakeWeb.register_uri(:post, mock_upload_url_for_handle(@group_handle), :body => response_for(Group, 'show', true))
    end
    
    after(:each) do
      FakeWeb.clean_registry
    end
    
    it "should be found via its course" do
      lambda { Track.find(@track_handle, @group_handle) }.should_not raise_error
    end
    
    it "should have a handle" do
      Track.find(@track_handle, @group_handle).handle.should_not == nil
    end
  end
end