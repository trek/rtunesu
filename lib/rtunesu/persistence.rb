module RTunesU
  module Persistence
    module Finder
      # Finds a specific entity in iTunes U. To find an entity you will need to know both its type 
      # (Course, Group, etc) and handle.  Handles uniquely identify entities in iTunes U and the entity 
      # type is used to search the returned XML for the specific entity you are looking for.  For example,
      # Course.find(123456, rtunes_connection_object)
      def find(handle, connection = nil)
        connection ||= self.base_connection

        entity = self.new
        entity.instance_variable_set('@handle', handle)
        entity.load_from_xml(connection.upload_file(RTunesU::SHOW_TREE_FILE, handle))
        entity

      rescue LocationNotFound
        raise EntityNotFound, "Could not find #{entity.class_name} with handle of #{handle}."
      end
    end
    
    def self.included(base)
      base.extend(Finder)
    end
    
    def load_from_xml(xml_or_entity)
      self.source_xml = Hpricot.XML(xml_or_entity).at("//ITunesUResponse//#{self.class_name}//Handle[text()=#{self.handle}]..")
    end
    
    # called when .save is called on an object that is already stored in iTunes U
    def update(connection = nil)
      connection ||= self.base_connection
      
      connection.process(Document::Merge.new(self).xml)
      edits.clear
      self
    end
    
    # called when .save is called on an object that has no Handle (i.e. does not already exist in iTunes U)
    def create(connection = nil)
      connection ||= self.base_connection
      
      response = Hpricot.XML(connection.process(Document::Add.new(self).xml))
      raise CannotSave, response.at('error').innerHTML if response.at('error')
      @handle = response.at('AddedObjectHandle').innerHTML
      edits.clear
      self
    end
    
    # Saves the entity to iTunes U.  Save takes single argument (an iTunes U connection object).  
    # If the entity is unsaved this will create the entity and populate its handle attribte.  
    # If the entity has already been saved it will send the updated data (if any) to iTunes U.
    def save(connection = nil)
      connection ||= self.base_connection
      saved? ? update(connection) : create(connection)
    end
    
    # Has the entity be previously saved in iTunes U
    def saved?
      self.handle ? true : false
    end
    
    # Deletes the entity from iTunes U.  This cannot be undone.
    def delete(connection = nil)
      connection ||= self.base_connection
      
      response = Hpricot.XML(connection.process(Document::Delete.new(self).xml))
      raise Exception, response.at('error').innerHTML if response.at('error')
      @handle = nil
      self
    end
  end
  [Course, Division, Group, Section, Site, Track].each do |entity|
    entity.send(:include, Persistence)
  end
end