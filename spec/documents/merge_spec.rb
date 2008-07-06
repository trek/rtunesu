require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU
include Document

describe Document::Merge do
  before  do
    course = mock(RTunesU::Course, :handle => 1234567,
                                   :path  => 'ExampleU/Humanities/HUM211',
                                   :class_name => 'Course')
    @document = Document::Merge.new(course)
  end
  
  it 'can convert itself to a string of xml' do
    lambda { @document.to_xml }.should_not raise_error
  end
  
  describe 'xml contents' do
    before do
      course = mock(RTunesU::Course, :handle => 1234567,
                                     :path  => 'ExampleU/Humanities/HUM211',
                                     :class_name => 'Course')
      document = Document::Merge.new(course)
      @xml = XmlSimple.xml_in(@document.to_xml, 'KeepRoot' => true, 'ForceArray' => false)
    end

    it 'has a handle that represents its entity' do
      @xml['ITunesUDocument']['DeleteCourse'].should have_key('CourseHandle')
    end
  
    it 'has a path that represents its entity' do
      @xml['DeleteCourse'].should have_key('CoursePath')
    end
  
    it 'has a child element that represents the source entity' do
      @xml['DeleteCourse'].should have_key('Course')
    end
  end
end
