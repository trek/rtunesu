require File.dirname(__FILE__) + '/../spec_helper.rb'
require File.dirname(__FILE__) + '/../entity_spec.rb'

include RTunesU

describe Section do
  before(:each) do
    @klass = Section
    @entity = Section.new
    @section = @entity
    @attributes = {:name => 'Sample Course'}
  end
  
  it_should_behave_like "an Entity"  
    
  it_should_be_composed_of :name
  it_should_have_many :courses
  
  describe "converted to XML" do
    describe "when new" do
      before(:each) do
        @document = Hpricot.XML(@section.to_xml)
      end

      it "should not have SectionPath element" do
        @document.at('SectionPath').should == nil
      end

      it "should not have MergeByHandle element" do
        @document.at('MergeByHandle').should == nil
      end

      it "should not have Destructive element" do
        @document.at('Destructive').should == nil
      end
    end
    
    describe "when saved" do
      before(:each) do
        @section.instance_variable_set("@handle", '1')
        @document = Hpricot.XML(@section.to_xml)
      end

      it "should have SectionPath element" do
        @document.at('SectionPath').should_not == nil
      end

      it "should have MergeByHandle element" do
        @document.at('MergeByHandle').should_not == nil
        @document.at('MergeByHandle').innerHTML.should == "false"
      end

      it "should have Destructive element" do
        @document.at('Destructive').should_not == nil
        @document.at('Destructive').innerHTML.should == "false"
      end
    end
  end
end