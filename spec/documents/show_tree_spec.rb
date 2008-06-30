require File.dirname(__FILE__) + '/../spec_helper.rb'
include RTunesU
include Document

describe Document, "ShowTree" do
  describe 'handle' do
    it 'should exist'
    it 'should default to the upload location'
    it 'can take a specific handle'
  end
  
  describe 'keygroup' do
    it 'should default to most'
    it 'cannot take values other than minimal, maximal, and most'
  end
end
