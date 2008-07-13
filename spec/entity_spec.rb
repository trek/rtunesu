require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

# describe Entity do
#   it 'finds itself in iTunes U'
#   it 'rasies an error if it cannot be found in iTunes U'
#   
#   it "saves to iTunes U"
#   it "appepts to saves if valid"
#   it "it won't attempt to save (and rasies an error) if it's missing require attributes"
#   
#   it "creates if it didn't previously exist"
#   it "updates if it previously existed"
#   
#   it "rasies an error if saving failed"
#   
#   it "deletes"
#   it "raises an error if delting failed"
#   
#   it "converts to an xml string"
#   it "creats from a ITunesU Response"
# end
describe Entity, 'attribute assignment' do
  before do
    @entity = Entity.new
  end
  
  it 'assigns singular attributes to the edits hash as a string' do
    @entity.Name = 'Eng211'
    @entity.edits['Name'].should eql('Eng211')
    @entity.Name.should eql('Eng211')
  end
  
  it 'returns a default empty array for plural attributes' do
    @entity.Groups.should eql([])
    @entity.edits['Groups'].should eql([])
  end
  
  it 'assigns plural attribute to the edits hash an array' do
    @entity.Groups = [Group.new(:name => 'does not matter')]
    @entity.Groups.size.should be(1)
    @entity.edits['Groups'].size.should be(1)
  end
  
  it 'adds plural attributes with <<' do 
    @entity.Groups = [Group.new(:name => 'does not matter')]
    @entity.Groups.size.should be(1)
    @entity.Groups << Group.new(:name => 'another group')
    @entity.edits['Groups'].size.should be(2)
  end
end

describe Entity, 'converting to XML' do
  describe 'with nested elements' do
    before do
      @entity = Entity.new(:Name => 'Example')
      @entity.Groups = [Group.new(:Name => 'example group 1'), Group.new(:Name => 'example group 2', :Description => 'Blah, blah, blah')]
      @xml = @entity.to_xml
    end
    
    it 'should contain nested XML edits' do
      (Hpricot.XML(@xml) / 'Entity/Group').size.should be(2)
    end
    
    it 'has nested elements that propely converted their singular attributes' do
       (Hpricot.XML(@xml) / 'Entity/Group')[0].at('Name').innerHTML.should eql('example group 1')
    end
    
  end
end

describe Entity, 'loading from XML' do
  before do
    @source = File.read(File.dirname(__FILE__) + '/fixtures/responses/generic_entity_response.xml')
    @entity = Entity.new(:handle => 789)
  end
  
  it 'access attributes from XML source or from the edits hash' do
    @entity.load_from_xml(@source)
    @entity.Name.should eql('Example Entity Inside of A Section')
    @entity.Name = 'new test name'
    @entity.Name.should eql('new test name')
  end
  
  it 'can reset its edits' do
    @entity.load_from_xml(@source)
    @entity.Name.should eql('Example Entity Inside of A Section')
    @entity.Name = 'new test name'
    @entity.Name.should eql('new test name')
    @entity.reload
    @entity.Name.should eql('Example Entity Inside of A Section')
  end
  
  it 'should find its appropriate node in the XML based on node name and <Handle> element' do
    @entity.load_from_xml(@source)
    @entity.source_xml.name.should eql('Entity')
  end
    
  it 'should raise an EntityNotFound error if the specific entity cannot be found' do
    @entity.handle = 1
    lambda { @entity.load_from_xml(@source) }.should raise_error(EntityNotFound)
  end
  
  it 'should still be able to access its parent XML node' do
    @entity.load_from_xml(@source)
    @entity.source_xml.parent.name.should eql('Section')
  end
end