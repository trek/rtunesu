require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU
include Document

describe Document::Add do
  before do
    course = mock(RTunesU::Course, :handle => 1234567,
                                   :parent_handle => 98765,
                                   :class_name => 'Course',
                                   :to_xml => '<Course></Course>')
    @document = Document::Add.new(course)
  end
  
  it 'can convert itself to a string of xml' do
    lambda { @document.xml }.should_not raise_error
  end
  
  describe 'xml contents' do
    before do
      course = Course.new(:handle => 1234567, :parent_handle =>  98765)
      @document = Document::Add.new(course)
      @xml = Hpricot.XML(@document.xml)
    end
    
    it 'has a source entity that defines the specific action name' do
      @xml.at('AddCourse').should_not be_nil
    end
  
    it 'has a parent handle' do
      @xml.at('AddCourse/ParentHandle').should_not be_nil
    end
    
    it 'has a parent path' do
      @xml.at('AddCourse/ParentPath').should_not be_nil
    end
    
    it 'has a child element that represents the source entity' do
      @xml.at('AddCourse/Course').should_not be_nil
    end
  end
end
