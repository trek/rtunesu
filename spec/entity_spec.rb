require File.dirname(__FILE__) + '/spec_helper.rb'
include RTunesU

shared_examples_for "an Entity" do
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
        @course = @klass.find(1)
      end
    end
    
    describe "with non-existant handle" do
      it "should raise EntityNotFound" do
        FakeWeb.register_uri(:get,
                             "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.1?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile",
                             :body => response_for(@klass, 'show', false),
                             :status => [404, "Not Found"]
                             )
        lambda { @course = @klass.find(1) }.should raise_error(EntityNotFound)
      end
    end
  end
end
