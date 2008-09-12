module RTunesU
  # A Track in iTunes U.
  # == Attributes
  # Name
  # Handle
  # Kind
  # TrackNumber
  # DiscNumber
  # DurationMilliseconds
  # AlbumName
  # ArtistName
  # GenreName
  # DownloadURL
  # Comment
  class Track < Entity
    # Tracks can only be found from within their Course. There is currently no way to find a Track separete from its Course in iTunes U.
    def self.find(handle, course_handle, connection)
      entity = self.new(:handle => handle)
      entity.source_xml = Course.find(course_handle, connection).source_xml.at("Handle[text()=#{entity.handle}]..")
      entity
    end
    
    # Duration in millseconds is the one attribute in plural form that is not a collection 
    def DurationMilliseconds
      self.value_from_edits_or_store('DurationMilliseconds')
    end
    
    # Duration in millseconds is the one attribute in plural form that is not a collection 
    def DurationMilliseconds=(duration)
      self.edits['DurationMilliseconds'] = duration
    end
  end
end