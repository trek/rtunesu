require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

describe Entity do
  it 'assigns attributes from a hash'
  
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
end