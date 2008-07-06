require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe Entity do
  describe 'metaprogramming aspects' do
    before do
      class Example < Entity
        attributes :bar, :baz, :handle
      end
      
      @example = Example.new(:bar => 'hi')
    end
    
    it 'dynamically creates getters' do
      @example.should respond_to(:baz)
    end
    
    it 'dynamically creats setters' do
      @example.should respond_to(:baz=)
    end
    
    it 'dynamically creats the attributes hash' do
      @example.should respond_to(:attributes)
      @example.attributes.should have_key(:baz)
    end
    
    it 'assigns attributes from a hash' do
      @example.bar.should eql('hi')
      @example.attributes[:bar].should eql('hi')
    end
    
  end
    
  it 'finds itself in iTunes U'
  it 'rasies an error if it cannot be found in iTunes U'
  
  it "saves to iTunes U"
  it "appepts to saves if valid"
  it "it won't attempt to save (and rasies an error) if it's missing require attributes"
  
  it "creates if it didn't previously exist"
  it "updates if it previously existed"
  
  it "rasies an error if saving failed"
  
  it "deletes"
  it "raises an error if delting failed"
  
  it "converts to an xml string"
  it "creats from a ITunesU Response"
end