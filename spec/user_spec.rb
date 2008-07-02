require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe User do
  before do
    @user = User.new(41, 'pietrekg', 'Trek', 'pietrekg@umich.edu')
    @user.credentials = ["Administrator@urn:mace:itunesu.com:sites:example.edu"]
  end
  
  it 'should convert to a properly formatted identity string' do    
    @user.to_identity_string.should eql('"Trek" <pietrekg@umich.edu> (pietrekg) [41]')
  end
  
  it 'should convert to a properly formatted credential string'
  
end
