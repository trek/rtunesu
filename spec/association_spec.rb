require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe "has-a assoctions" do
  
end

describe "has-n assoctions" do
  before(:each) do
    mock_connect!
    id = 2628591672
    FakeWeb.register_uri(:get,
                         "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.#{id}?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                         :body => mock_upload_url_for_handle(id))
    FakeWeb.register_uri(:post, mock_upload_url_for_handle(id), :body => response_for(Group, 'show', true))
    @group = Group.find(id)
  end
  
  after(:each) do
    FakeWeb.clean_registry
  end
  
  it "should access the subentity" do
    @group.tracks.should_not be_nil
  end
  
  it "should report the collections size" do
    @group.tracks.size.should == 2
  end
  
  it "should allow clearing the collections" do
    @group.tracks.clear.should == []
  end
  
  it "should allow subselections of the collections" do
    @group.tracks[1].should be_kind_of(Track)
  end
  
  it "should allow access to the subentity's attributes" do
    @group.tracks[0].name.should_not == nil
  end
end