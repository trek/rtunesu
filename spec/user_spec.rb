require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe User do
  before do
    @user = User.new(42, 'jdoe', 'Jane Doe', 'jdoe@example.edu')
    @user.credentials = ['Administrator@urn:mace:itunesu.com:sites:example.edu']
  end
  
  it 'should convert to a properly formatted identity string' do    
    @user.to_identity_string.should eql('"Jane Doe" <jdoe@example.edu> (jdoe) [42]')
  end
  
  it 'should convert to a properly formatted credential string' do
    @user.to_credential_string.should eql('Administrator@urn:mace:itunesu.com:sites:example.edu')
  end
end
