require 'rubygems'
require 'spec'

require 'fakeweb'
FakeWeb.allow_net_connect = false

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'rtunesu'

def fixture_file(name)
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}")
end

def response_for(klass, action, success)
  success_string = success ? "success" : "failure"
  File.read(File.dirname(__FILE__) + "/fixtures/responses/#{success_string}/#{action}_#{klass.name.demodulize.downcase}.xml")
end

def it_should_be_composed_of(*elems)
  options = elems.extract_options!
  elems.each do |attr|
    it "should read attribute #{attr.to_s}" do
      @entity.should respond_to(attr)
    end
    
    if options[:readonly]
      it "should not write attrbiute #{attr.to_s}" do
        @entity.should_not respond_to("#{attr}=")
      end
    else
      it "should write attrbiute #{attr.to_s}" do
        @entity.should respond_to("#{attr}=")
      end
    end
  end
end

def it_should_have_many(*associations)
  associations.each do |association|
    it "should have many #{association}" do
      @entity.should respond_to(association)
      @entity.send(association).should be_kind_of(HasNEntityCollectionProxy)
    end
  end
end

def it_should_have_a(*associations)
  associations.each do |association|
    it "should have a #{association}" do
      @entity.should respond_to(association)
      @entity.send(association).should be_kind_of(HasAEntityCollectionProxy)
    end
  end
end

def mock_upload_url_for_handle(handle)
  "https://deimos.apple.com/FAKEWEB/UPLOADURL/#{handle}"
end

def mock_connect!
   now = Time.new
   Time.stub!(:now).and_return(now)
   now.stub!(:to_i).and_return(1214619134)

   user = mock(RTunesU::User, :id => 0,
                              :username => 'admin',
                              :name => 'Admin',
                              :email => 'admin@example.edu',
                              :credentials => ['Administrator@urn:mace:itunesu.com:sites:example.edu'],
                              :to_credential_string => 'Administrator@urn:mace:itunesu.com:sites:example.edu',
                              :to_identity_string => '"Admin" <admin@example.edu> (admin) [0]')
                              
   @connection = Connection.new(:user => user, :site => 'example.edu', :shared_secret => 'STRINGOFTHIRTYTWOLETTERSORDIGITS')
   RTunesU::Entity.set_base_connection(@connection)
   return "https://deimos.apple.com/WebObjects/Core.woa/API/GetUploadURL/example.edu.1?credentials=Administrator%40urn%3Amace%3Aitunesu.com%3Asites%3Aexample.edu&identity=%22Admin%22+%3Cadmin%40example.edu%3E+%28admin%29+%5B0%5D&time=1214619134&signature=121a6cf76c9c5ecda41450d87e3394b9d02c570a5f76b2bd16287f860f068302&type=XMLControlFile"
end