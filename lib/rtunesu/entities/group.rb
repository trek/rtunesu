module RTunesU
  # A Group in iTunes U. A Group is expressed as a tab in the iTunes interface.
  
  class Group < Entity
    ACCESS = {
      :no_access => "No Access",
      :steaming  => "Streaming",
      :download  => "Download",
      :drop_box  => "Drop Box",
      :shared    => "Shared",
      :edit      => "Edit"
    }
    composed_of :name, :group_type, :short_name, :allow_subscription, :explicit
    composed_of :aggregate_file_size, :readonly => true
    validates! :group_type, [:simple, :smart, :feed]
    has_a :external_feed
    has_n :permissions, :tracks, :shared_objects
    
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      if self.external_feed
        self.to_xml_with_feed(xml_builder)
      else
        super
      end
    end
    
    def to_xml_with_feed(xml_builder)
      xml_builder.tag!('Name', self.name)
      xml_builder.tag!('GroupType', self.group_type)
      xml_builder.tag!('ExternalFeed', self.external_feed.to_xml(xml_builder))
      
      edit_store = {
        "Name" => self.edits["Name"],
        "GroupType" => self.edits["GroupType"],
        "ExternalFeed" => self.edits["ExternalFeed"]
      }
      
      xml = self.to_xml(xml_builder)
      
      self.edits.merge!(edit_store)
      return xml
    end
  end
end