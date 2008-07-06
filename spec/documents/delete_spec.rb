require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU
include Document

describe Document::Delete do
  before  do
    course = mock(RTunesU::Course, :handle => 1234567,
                                   :path  => 'ExampleU/Humanities/HUM211',
                                   :class_name => 'Course')
    @document = Document::Delete.new(course)
  end
  
  it 'can convert itself to a string of xml' do
    lambda { @document.to_xml }.should_not raise_error
  end
  
  describe 'xml contents' do
    before do
      course = mock(RTunesU::Course, :handle => 1234567,
                                     :path  => 'ExampleU/Humanities/HUM211',
                                     :class_name => 'Course')
      document = Document::Delete.new(course)
      @xml = XmlSimple.xml_in(@document.to_xml, 'KeepRoot' => true, 'ForceArray' => false)
    end

    it 'has a parent handle' do
      @xml['ITunesUDocument']['DeleteCourse'].should have_key('ParentHandle')
    end
  
    it 'has a parent path' do
      @xml['DeleteCourse'].should have_key('ParentPath')
    end
  
    it 'has a child element that represents the source entity' do
      @xml['DeleteCourse'].should have_key('Course')
    end
  end
end
