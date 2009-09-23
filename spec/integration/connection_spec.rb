require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

# Integration testing server provided by Apple:
# http://deimos.apple.com/rsrc/doc/iTunesUAdministratorsGuide/AdministeringSiteAccess/chapter_7_section_11.html
describe "connections" do
  before(:each) do
    now = Time.new
    Time.stub!(:now).and_return(now)
    now.stub!(:to_i).and_return(1147136717)
    
    @user = RTunesU::User.new(42, 'jdoe', 'Jane Doe','janedoe@example.edu')
    @user.credentials = ['Administrator@urn:mace:itunesu.com:sites:example.edu']
    @connection = RTunesU::Connection.new(:user => @user, :site => 'example.edu', :shared_secret => 'STRINGOFTHIRTYLETTERSORNUMBERS', :debug_suffix => 'abc123')
  end
  
  it "should show tree" do
    puts @connection.show_tree
  end
end