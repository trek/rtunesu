require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

# Testing data provided by Apple:
# http://deimos.apple.com/rsrc/doc/iTunesUAdministratorsGuide/AdministeringSiteAccess/chapter_7_section_11.html

describe "token generation" do
  VALID_TOKEN_STRING = 'credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Jane+Doe%22+%3Cjanedoe%40example.edu%3E+%28jdoe%29+%5B42%5D&time=1147136717&signature=597c304e90fb62067c7e3fa57fe824e77997dd8aa96649366c5fc59104074744'
  
  before(:each) do
    now = Time.new
    Time.stub!(:now).and_return(now)
    now.stub!(:to_i).and_return(1147136717)
    
    user = RTunesU::User.new(42, 'jdoe', 'Jane Doe','janedoe@example.edu')
    user.credentials = ['Administrator@urn:mace:itunesu.com:sites:example.edu']
    @connection = Connection.new(:user => user, :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
  end
  
  it "should generate a valid token string" do
    @connection.generate_authorization_token.should == VALID_TOKEN_STRING
  end
end