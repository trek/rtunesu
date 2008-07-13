module RTunesU
  class Track < Entity
    # Tracks can only be found from within their Course
    def self.find(handle, course_handle, connection)
      entity = self.new(:handle => handle)
      entity.source_xml = Course.find(course_handle, connection).source_xml.at("Handle[text()=#{entity.handle}]..")
      entity
    end
  end
end