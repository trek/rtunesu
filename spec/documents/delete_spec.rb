require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU
include Document

describe Document::Delete do
  before  do
    course = Course.new(:handle => 1234567, :parent_handle =>  98765)
    @document = Document::Delete.new(course)
  end
  
  it 'can convert itself to a string of xml' do
    lambda { @document.xml }.should_not raise_error
  end
  
  describe 'xml contents' do
    before do
      course = Course.new(:handle => 1234567, :parent_handle =>  98765)
      document = Document::Delete.new(course)
      @xml = XmlSimple.xml_in(@document.xml, 'KeepRoot' => true, 'ForceArray' => false)
    end

    it 'has a parent handle' do
      @xml['ITunesUDocument']['DeleteCourse'].should have_key('CourseHandle')
    end
  
    it 'has a parent path' do
      @xml['ITunesUDocument']['DeleteCourse'].should have_key('CoursePath')
    end
  end
end
