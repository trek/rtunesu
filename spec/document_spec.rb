require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU
include Document

[Course, Division, Section, Group].each do |klass|
  [:Add, :Merge, :Delete].each do |action|
    describe "Document building for #{klass} for #{action}" do
      before(:each) do
        @entity = klass.new
        @entity.parent_handle = '1'
        @document = Hpricot.XML(Document.const_get(action).new(@entity).xml)
      end
      
      it "should have a base element of ITunesUDocument" do
        @document.at("ITunesUDocument").should_not be_nil
      end
      
      it "should have a Version element with the iTunesU Version as content" do
        @document.at("ITunesUDocument/Version").should_not be_nil
      end
    end
  end
  
  describe "Document::Add for #{klass}" do
    before(:each) do
      @entity = klass.new
      @entity.parent_handle = '1'
      @document = Hpricot.XML(Document::Add.new(@entity).xml)
    end
    
    it "should raise error without parent handle" do
      @entity.parent_handle = nil
      lambda { Hpricot.XML(Document::Add.new(@entity).xml) }.should raise_error(MissingParent)
    end
    
    it "should have a Add element" do
      @document.at("ITunesUDocument/Add#{@entity.class_name}").should_not be_nil
    end

    it "should have a ParentHandle element" do
      @document.at("ITunesUDocument/Add#{@entity.class_name}/ParentHandle").should_not be_nil
    end

    it "should have a ParentPath element" do
      @document.at("ITunesUDocument/Add#{@entity.class_name}/ParentPath").should_not be_nil
    end
    
    it "should have an element for its Entity" do
      @document.at("ITunesUDocument/Add#{@entity.class_name}/#{@entity.class_name}").should_not be_nil
    end
  end
  
  describe "Document::Merge for #{klass}" do
    before(:each) do
      @entity = klass.new
      @document = Hpricot.XML(Document::Merge.new(@entity).xml)
    end
    
    it "should have a Merge element" do
      @document.at("ITunesUDocument/Merge#{@entity.class_name}").should_not be_nil
    end
    
    it "should have a Handle element" do
      @document.at("ITunesUDocument/Merge#{@entity.class_name}/#{@entity.class_name}Handle").should_not be_nil
    end
    
    it "should have an element for its Entity" do
      @document.at("ITunesUDocument/Merge#{@entity.class_name}/#{@entity.class_name}").should_not be_nil
    end
  end
  
  describe "Document::Delete for #{klass}" do
    before(:each) do
      @entity = klass.new
      @document = Hpricot.XML(Document::Delete.new(@entity).xml)
    end
    
    it "should have a Delete element" do
      @document.at("ITunesUDocument/Delete#{@entity.class_name}").should_not be_nil
    end
    
    it "should have a Handle element" do
      @document.at("ITunesUDocument/Delete#{@entity.class_name}/#{@entity.class_name}Handle").should_not be_nil
    end

    it "should have a Path element" do
      @document.at("ITunesUDocument/Delete#{@entity.class_name}/#{@entity.class_name}Path").should_not be_nil
    end
  end
end