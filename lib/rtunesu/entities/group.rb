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
    TYPES = {
      :feed => "Feed"
    }
    composed_of :name, :group_type, :short_name, :allow_subscription, :explicit
    composed_of :aggregate_file_size, :readonly => true
    validates! :group_type, [:simple, :smart, :feed]
    has_a :external_feed
    has_n :permissions, :tracks, :shared_objects
    
    # a Group must serialize in a specific order
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!('Group') do
        %w(Name Handle GroupType Explicit).each do |tag_name|
          xml_builder.tag!(tag_name, self.edits[tag_name]) if self.edits[tag_name]
        end
        
        self.tracks.to_xml(xml_builder)
        self.permissions.to_xml(xml_builder)
        
        %w(AllowSubscription).each do |tag_name|
          xml_builder.tag!(tag_name, self.edits[tag_name]) if self.edits[tag_name]
        end
        self.external_feed.to_xml(xml_builder) if self.external_feed
      end
    end
  end
end