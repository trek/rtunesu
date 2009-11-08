module RTunesU
  class ExternalFeed < Entity
    composed_of :polling_interval, :owner_email, :security_type, :signature_type, :basic_auth_username, :basic_auth_password
    composed_of :url, :as => 'URL'
    validates!  :polling_interval, [:never, :daily]
    validates!  :security_type,  [:none, 'Basic Authentication']
    
    # an ExternalFeed must serialize in a specific order
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!('ExternalFeed') do
        %w(URL OwnerEmail PollingInterval SecurityType SignatureType BasicAuthUsername BasicAuthPassword).each do |tag_name|
          xml_builder.tag!(tag_name, self.edits[tag_name]) if self.edits[tag_name]
        end
      end
    end
    
    # As an entirely nested entity ExternalFeed instances don't have a parent handle. However, something 'truthy' needs
    # to be presnet for proper XML document genration.
    def parent_handle # :nodoc:
      ""
    end
  end
end