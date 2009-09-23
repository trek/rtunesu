require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe Connection do  
  describe 'requesting an upload location for a file' do
  end
  
  describe 'API accessing' do
    before do
      now = Time.new
      Time.stub!(:now).and_return(now)
      now.stub!(:to_i).and_return(1214619134)

      user = mock(RTunesU::User, :id => 0,
                                 :username => 'admin',
                                 :name => 'Admin',
                                 :email => 'admin@example.edu',
                                 :credentials => ['Administrator@urn:mace:itunesu.com:sites:example.edu'],
                                 :to_credential_string => 'Administrator@urn:mace:itunesu.com:sites:example.edu',
                                 :to_identity_string => '"Admin" <admin@example.edu> (admin) [0]')
                                 
      @connection = Connection.new(:user => user, :site => 'example.edu', :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
    end
    
    it 'access a web services url for the institution' do
      @connection.webservices_url.should eql('https://deimos.apple.com/WebObjects/Core.woa/API/ProcessWebServicesDocument/example.edu?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302')
    end
    
    it 'can generate a url for uploading files'
    it 'opens an HTTPS connection to iTunes U'
    it 'send XML data'
    it 'generates a url user access to a location through iTunes U'
  end
end
