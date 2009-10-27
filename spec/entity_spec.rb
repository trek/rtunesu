require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU
shared_examples_for "an updateable Entity" do
  describe "updating" do
    before(:each) do
      mock_connect!
      @entity = @klass.new(@attributes)
      @entity.instance_variable_set("@handle", '1')
      @entity.parent_handle = '1'
    end
    
    it "should clear its edits" do
      FakeWeb.register_uri(:post,
                            "https://deimos.apple.com/WebObjects/Core.woa/API/ProcessWebServicesDocument/example.edu?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302",
                            :body => response_for(@klass, 'update', true)
                          )
      @entity.name = 'some name'
      @entity.edits.should_not be_empty
      @entity.save
      @entity.edits.should be_empty
    end
    
  end
  
  
end

shared_examples_for "a deleteable Entity" do
  describe "deleting" do
    before(:each) do
      mock_connect!
      @entity = @klass.new(@attributes)
      @entity.instance_variable_set("@handle", '1')
      @entity.parent_handle = '1'
    end
    
    it "should no longer have a handle" do
      FakeWeb.register_uri(:post,
                            "https://deimos.apple.com/WebObjects/Core.woa/API/ProcessWebServicesDocument/example.edu?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302",
                            :body => response_for(@klass, 'delete', true)
                          )
      @entity.delete
      @entity.handle.should == nil
    end
  end
end

shared_examples_for "a findable Entity" do
  describe "finding" do
    before(:each) do
      mock_connect!
    end
    
    after(:each) do
      FakeWeb.clean_registry
    end
    
    describe "with existing handle" do
      it "should load external data into object" do
        FakeWeb.register_uri(:get,
                             "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.1?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                             :body => mock_upload_url_for_handle(1))
        FakeWeb.register_uri(:post, mock_upload_url_for_handle(1), :body => response_for(@klass, 'show', true))
        @entity = @klass.find(1)
      end
    end
    
    describe "with non-existant handle" do
      it "should raise EntityNotFound" do
        FakeWeb.register_uri(:get,
                             "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.1?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                             :body => response_for(@klass, 'show', false),
                             :status => [404, "Not Found"]
                             )
        lambda { @entity = @klass.find(1) }.should raise_error(EntityNotFound)
      end
    end
  end
end

shared_examples_for "a creatable Entity" do
  describe "creating" do
    before(:each) do
      mock_connect!
      @entity = @klass.new(@attributes)
      @entity.parent_handle = '1'
      @entity.handle.should == nil
    end
    
    after(:each) do
      FakeWeb.clean_registry
    end
    
    it "should not have a handle until saved" do
      @entity.handle.should == nil
    end
    
    it "should obtain a handle from iTunes U when saved" do
      FakeWeb.register_uri(:post,
                            "https://deimos.apple.com/WebObjects/Core.woa/API/ProcessWebServicesDocument/example.edu?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302",
                            :body => response_for(@klass, 'create', true)
                          )
      @entity.save
      @entity.handle.should_not == nil
    end
    
    it "should raise InvalidRecord if it cannot be saved" do
      FakeWeb.register_uri(:post,
                            "https://deimos.apple.com/WebObjects/Core.woa/API/ProcessWebServicesDocument/example.edu?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302",
                            :body => response_for(@klass, 'create', false)
                          )
      lambda { @entity.save }.should raise_error(CannotSave)
    end
    
    it "should clear its edits" do
      FakeWeb.register_uri(:post,
                            "https://deimos.apple.com/WebObjects/Core.woa/API/ProcessWebServicesDocument/example.edu?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302",
                            :body => response_for(@klass, 'create', true)
                          )
      @entity.name = 'some name'
      @entity.edits.should_not be_empty
      @entity.save
      @entity.edits.should be_empty
    end
  end
end

shared_examples_for "an Entity with attribute assignment" do
  it "should initialize with optional starting attributes" do
    @entity = @klass.new(@attributes)
    @attributes.each do |attr,value|
      @entity.send(attr).should == value
    end
  end
  
  describe "accessing handle" do
    describe "when handle instance variable is set" do
      it "should return the handle" do
        @entity.instance_variable_set("@handle", "1")
        @entity.handle.should == "1"
      end
      
      it "should use id as alias for handle" do
        @entity.instance_variable_set("@handle", "1")
        @entity.handle.should == @entity.id
      end
    end
    
    describe "when handle instance variable is not set" do
      it "should access the handle from source xml if availabe" do
        @entity.source_xml = Hpricot.XML(<<-XML
          <#{@klass.name.demodulize}>
            <Handle>1</Handle>
          </#{@klass.name.demodulize}>
        XML
        )
        @entity.handle.should == "1"
      end
      
      it "should retrun nil if source xml doesn't contain handle" do
        @entity.handle.should be_nil
      end
    end
  end
end


shared_examples_for "an Entity" do
  it_should_behave_like "a creatable Entity"
  it_should_behave_like "a findable Entity"
  it_should_behave_like "an updateable Entity"
  it_should_behave_like "a deleteable Entity"
  it_should_behave_like "an Entity with attribute assignment"
end
