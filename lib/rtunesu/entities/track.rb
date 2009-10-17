module RTunesU
  class Track < Entity
    composed_of :name, :kind, :disc_number, :album_name, :arist_name, :category_code, :explicit
    composed_of :duration_in_milliseconds, :readonly => true
    composed_of :downloadURL, :as => 'DownloadURL'
    
    # Tracks can only be found from within their Course. 
    # There is currently (v1.1.3) no way to find a Track separete from its Course in iTunes U.
    def self.find(handle, course_handle, connection = nil)
      connection = connection || self.base_connection
      
      entity = self.new(:handle => handle)
      entity.source_xml = Course.find(course_handle, connection).source_xml.at("Handle[text()=#{entity.handle}]..")
      entity
    end
  end
end
