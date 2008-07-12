require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe Document do
  before(:all) do
    @xml = Document::Merge.new(Course.new).xml
  end
  
  it 'includes a base element of ITunesUDocument' do
    (Hpricot.XML(@xml) % 'ITunesUDocument').should_not be_nil
  end
  
  it 'includes a version number' do
    (Hpricot.XML(@xml) % 'ITunesUDocument/Version').should_not be_nil
  end
end
