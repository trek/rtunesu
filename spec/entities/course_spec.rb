require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU

describe Course do
  before do
    u = RTunesU::User.new(0, 'admin', 'Admin', 'admin@example.com')
    u.credentials = ['Administrator@urn:mace:umich.edu']
    @connection = RTunesU::Connection.new(:user => u, :site => 'example.edu', :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
  end
  
  describe 'finding' do
    it 'can find itself in iTunesU' do
      @connection.should_receive(:process).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
      @course = Course.find(1257981186, @connection)
    end
  end
  
  describe ' after successful finding' do
    before(:all) do
      @connection.should_receive(:process).and_return(File.open(File.dirname(__FILE__) + '/../fixtures/responses/show_tree_course.xml'))
      @course = Course.find(1257981186, @connection)
    end
        
    it 'should access its attributes from the returned xml' do
      @course.Name.should eql('SI 539 001 W07')
      @course.Handle.should eql('1257981186')
    end
    
    it 'should find its parent element' do
      @course.parent.should be_an_instance_of(RTunesU::Section)
    end
    
    it 'should be able to find its groups (tabs)' do
      @course.Groups.should    be_an_instance_of(Array)
      @course.Groups[0].should be_an_instance_of(RTunesU::Group)
    end
    
    it 'should be able to access it groups attributes' do
      @course.Groups[0].Handle.should eql('1257981189')
    end
    
    it 'should be able to access it groups tracks' do
      @course.Groups[0].Tracks.should be_an_instance_of(Array)
      @course.Groups[0].Tracks[0].should be_an_instance_of(RTunesU::Track)
    end
  end
end