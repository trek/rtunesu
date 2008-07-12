require 'rubygems'
require 'cgi'
require 'hmac'
require 'hmac-sha2'
require 'digest'
require 'net/https'
require 'uri'
require 'timeout'

module RTunesU
  # Connection is a class for opening and using a connection to the iTunes U Webservices system.  To open a connection to iTunes U, you first need to create a RTunesU::User object using the administrator data you received from Apple when they created your iTunes U site.
  # === Creating a Connection
  # include RTunesU
  # # create a new admin user from our Institution's login information
  # user = User.new(0, 'admin', 'Admin', 'admin@example.edu')
  # # set the User credentials to the credentials Apple provider when we signed up
  # user.credentials = ['Administrator@urn:mace:example.edu']
  # # Create a new Connection object.
  # connection = Connection.new(:user => user, :site => 'example.edu', :shared_secret => 'STRINGOFTHIRTYLETTERSORNUMBERS')
  # 
  # === Using a Connection
  # A Connection object is needed for operations that communicate with Apple's iTunes U Webservices.  For example, calls to .save, .create, .update, and .delete on Entity objects take a Connection object as their only argument.
  # To communicate with the iTunes U Service, a Connection object will generate proper authentication data, hash your request, and (if neccessary) send XML data to iTunes U.
  # For more inforamtion about this processs see: http://deimos.apple.com/rsrc/doc/iTunesUAdministratorsGuide/IntegratingAuthenticationandAuthorizationServices/chapter_3_section_3.html
  # === Scaling tips
  # Because the you will likely only need a single unchanging Connection object for your application you may wish to initialize a single Connection object for the admin credentials at application start time and assign it to a constant. This is especially beneficial for long running applications like web applications.
  class Connection
    TIMEOUT = 240
    
    attr_accessor :user, :options
    
    def initialize(options = {})
      self.user, self.options = options[:user], options
    end
    
    # iTunes U requires all request to include an authorization token that includes a User's credentials, indetifiying information, and the time of the request.  This data is hashed against your institution's shared secret (provider by Apple with your iTunes U account information). Because tokens are valid only for 90 seconds they are generated for each request attempt.
    def generate_authorization_token
    	# create the token that contains the necessary elements to authorize the user	
    	# using a nested array because the alphabetical order must be maintained
    	token = [['credentials', self.user.to_credential_string,], ['identity', self.user.to_identity_string], ['time', Time.now.to_i.to_s]]
    	encoded_parms = token.collect {|pair| pair[1] = CGI.escape(pair[1]); pair.join('=')}.join('&')

      digest = Digest::SHA2.new
      digest.update(encoded_parms)

      hmac = HMAC::SHA256.new(self.options[:shared_secret])
      hmac.update(encoded_parms)

      # add the hashed digital signature to the end of the query parameters
      encoded_parms += "&signature=#{hmac.hexdigest}"
    end
        
    def upload_url_for_location(location)
      url_string = "#{API_URL}/GetUploadURL/#{self.options[:site]}.#{location.handle}?#{self.generate_authorization_token}"
      puts url_string
      url = URI.parse(url_string)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response = http.start {|http| 
        http.request(Net::HTTP::Get.new(url.path + '?' + url.query))
      }
      response.body
    end
    
    # The URL that receives all iTunes U webservices requests.  This is different for each institution and inclues your site name provided by Apple.
    def webservices_url
      "#{API_URL}/ProcessWebServicesDocument/#{options[:site]}?#{self.generate_authorization_token}"
    end
    
    # 
    def browse_url
      "#{BROWSE_URL}/#{options[:site]}?#{self.generate_authorization_token}"
    end
    
    def show_tree
      url = URI.parse("#{SHOW_TREE_URL}/#{options[:site]}?#{self.generate_authorization_token}")
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start {
          request = Net::HTTP::Post.new(url.to_s)
          response = http.request(request)
          response.body
        }
    end
    
    #  Sends a string of XML data to iTunes U's webservices url for processing.  Returns the iTunes U response XML. Used by Entity objects to send generated XML to iTunes U. 
    def process(xml)
      timeout(TIMEOUT) do
        url = URI.parse(webservices_url)
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.start {
            request = Net::HTTP::Post.new(url.to_s)
            request.body = xml
            response = http.request(request)
            response.body
          }
      end
    end
    
    def upload_file(file, location)
      upload_location = upload_url_for_location(location)
      url = URI.parse(upload_location)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.start {
          request = Net::HTTP::Post.new(url.to_s)
          request.body = file.open
          response = http.request(request)
          response.body
        }
    end
  end
end