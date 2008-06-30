require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe Connection do
  describe 'token generation' do
    before do 
      user = mock(RTunesU::User, :id => 0,
                                 :username => 'admin',
                                 :name => 'Admin',
                                 :email => 'admin@example.edu',
                                 :credentials => ['Administrator@urn:mace:itunesu.com:sites:example.edu'],
                                 :credential_string => 'Administrator@urn:mace:itunesu.com:sites:example.edu',
                                 :to_s => '"Admin" <admin@example.edu> (admin) [0]')
                                 
      @connection = Connection.new(:user => user, :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
      @connection.generate_authorization_token(Time.at(1214619134))
    end
    
    it 'generates a token' do
      @connection.token.should eql("credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302")
    end
    
    it 'does not allow illegal characters'
    it 'includes a properly hashed signature'
  end
  
  describe 'requesting upload location' do
    
  end
end
