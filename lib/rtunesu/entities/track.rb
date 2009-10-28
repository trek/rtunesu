module RTunesU
  class Track < Entity
    attr_accessor :file
    composed_of :name, :kind, :disc_number, :track_number, 
                :album_name, :arist_name, :category_code, :explicit,
                :genre_name, :comment
                
    composed_of :duration_in_milliseconds, :as => 'DurationMilliseconds', :readonly => true
    composed_of :download_url, :as => 'DownloadURL', :readonly => true
    has_a :remote_file, :as => 'File', :readonly => true
    
    
    def create(connection = nil)
      connection ||= self.base_connection
      if file
        response = connection.upload_file(file, self.parent_handle, false)
        @parent_handle, @handle = response.split('.')[-2..-1]
        self.source_xml = Group.find(@parent_handle, connection).source_xml.at("Track/Handle[text()=#{@handle}]/..")
        self
      else
        super
      end
    end
    
    def update(connection = nil)
      raise "Cannot save existing Track with new file attached. Delete the old track and create a new one instead."  if file
      super
    end
    
    # Tracks can only be found from within their Course. 
    # There is currently (v1.1.3) no way to find a Track separete from its Course in iTunes U.
    def self.find(handle, group_handle, connection = nil)
      connection ||= self.base_connection
      
      track = self.new
      track.instance_variable_set('@handle', handle)
      track.source_xml = Group.find(group_handle, connection).source_xml.at("Track/Handle[text()=#{handle}]/..")
      track
    end
  end
end
