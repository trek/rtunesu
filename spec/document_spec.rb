require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe Document do
  before do
    @document = Document::Base.new(RTunes::Course.new)
  end
  
  it 'includes a base element of ITunesUDocument'
  it 'includes a version number'
end
