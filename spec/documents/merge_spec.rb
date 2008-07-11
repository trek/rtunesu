require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU
include Document

describe Document::Merge do
  before  do
    course = Course.new(:handle => 1234567, :parent_handle =>  98765)
    @document = Document::Merge.new(course)
  end
  
  it 'can convert itself to a string of xml' do
    lambda { @document.xml }.should_not raise_error
  end
  
  describe 'xml contents' do
    before do
      course = Course.new(:handle => 1234567, :parent_handle =>  98765)
      document = Document::Merge.new(course)
      @xml = XmlSimple.xml_in(@document.xml, 'KeepRoot' => true, 'ForceArray' => false)
    end

    it 'has a handle that represents its entity' do
      @xml['ITunesUDocument']['MergeCourse'].should have_key('CourseHandle')
    end
  
    it 'has a child element that represents the source entity' do
      @xml['ITunesUDocument']['MergeCourse'].should have_key('Course')
    end
  end
end
