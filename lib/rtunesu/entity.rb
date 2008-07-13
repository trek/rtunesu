require 'hpricot'

module RTunesU
  # A Base class reprenseting the various entities seen in iTunes U.  Subclassed into the actual entity classes (Course, Division, Track, etc).  Entity is mostly an object oriented interface to the underlying XML data returned from iTunes U.  Most of attributes of an Entity are read by searching the souce XML returned from iTunes U by the Entity class's implemention of method_missing. 
  # Attribute of an Entity are written through method missing as well.  Methods that end in '=' will write data that will be saved to iTunes U.
  # == Reading and Writing Attributes
  # c = Course.find(12345, rtunes_connection_object) # finds the Course in iTunes U and stores its XML data
  # c.Handle # finds the <Handle> element in the XML data and returns its value (in this case 12345)
  # c.Name   # finds the <Name> element in the XML data and returns its value (e.g. 'My Example Course')
  # c.Name = 'Podcasting: a Revolution' # writes a hash of unsaved data that will be sent to iTunes U.
  #
  # == Accessing related entities 
  # Related Entity objects are accessed with the pluralized form of their class name.  To access a Course's related Group entities, you would use c.Groups. This will return an array of Group objects (or an empty Array object if there are no associated Groups)
  # You can set the array of associated entities by using the '=' form of the accessor and add anothe element to the end of an array of related entities with '<<'
  # Examples:
  # c = Course.find(12345, rtunes_connection_object) # finds the Course in iTunes U and stores its XML data
  # c.Groups # returns an array of Group entities or an empty array of there are no Group entities
  # c.Groups = [Group.new(:Name => 'Lectures')] # assigns the Groups related entity array to an existign array (overwriting any local data about Groups)
  # c.Groups << Group.new(:Name => 'Videos') # Adds the new Group object to the end of hte Groups array
  # c.Groups.collect {|g| g.Name} # ['Lectures', 'Videos']
  #
  # == Notes on arbitrary XML
  # Because Entity is, at heart, an object oriented wrapper for iTunes U XML data it is possible to add arbitrary (and possibly meaningless or invalidating) data that will be sent to iTunes U.  You should have a solid understanding of how Entites relate in iTunes U to avoind sending bad data.
  # Examples:
  # c = Course.find(12345, rtunes_connection_object)
  # c.Junk = 'some junk xml' 
  # c.save
  # # c.save will generate XML that inclucdes 
  # # <Course>
  # #   <Junk>some junk xml</Junk>
  # #   ... some other XML data ...
  # # </Course>
  # # this XML may raise errors in iTunes U because it doesn't match valid iTunes U documents
  
  
  
  
  class Entity
    attr_accessor :connection, :attributes, :handle, :parent, :parent_handle, :saved, :source_xml
    
    # Creates a new Entity object with attributes based on the hash argument  Some of these attributes are assgined to instance variables of the obect (if there is an attr_accessor for it), the rest will be written to a hash of edits that will be saved to iTunes U using method_missing
    def initialize(attrs = {})
      self.attributes = {}
      attrs.each {|attribute, value| self.send("#{attribute}=", value)}
    end
    
    # Finds a specific entity in iTunes U. To find an entity you will need to know both its type (Course, Group, etc) and handle.  Handles uniquely identify entities in iTunes U and the entity type is used to search the returned XML for the specific entity you are looking for.  For example,
    # Course.find(123456, rtunes_connection_object)
    def self.find(handle, connection)
      entity = self.new(:handle => handle)
      entity.load_from_xml(connection.process(Document::ShowTree.new(entity).xml))
      entity
    end
        
    def load_from_xml(xml)
      self.source_xml = Hpricot.XML(xml).at("//ITunesUResponse//#{self.class_name}//Handle[text()=#{self.handle}]..")
      raise EntityNotFound if self.source_xml.nil?
    end
    
    # Edits stores the changes made to an entity
    def edits
      @edits ||= {}
    end
    
    # Clear the edits and restores the loaded object to its original form
    def reload
      self.edits.clear
    end
    
    # Returns the parent of the entity
    def parent
      @parent ||= Object.module_eval(self.source_xml.parent.name).new(:source_xml => self.source_xml.parent)
    rescue
      nil
    end
    
    def method_missing(method_name, args = nil)
      # introspect the kind of method call (read one attribute, read an array of related items, write one attribute, write an array of related items)
      case method_name.to_s.match(/(s)*(=)*$/).captures
       when [nil, "="] : self.edits[method_name.to_s[0..-2]] = args
       when ["s", "="] : self.edits[method_name.to_s[0..-2]] = args
       when [nil, nil] : value_from_edits_or_store(method_name.to_s)
       when ["s", nil] : value_from_edits_or_store(method_name.to_s, true)
      end
    rescue NoMethodError
      raise NoMethodError, "undefined method '#{method_name}' for #{self.class}"
    end
    
    def value_from_edits_or_store(name, multi = false)
      if multi
        begin
          self.edits[name] || (self.source_xml / name.to_s.chop).collect {|el| Object.module_eval(el.name).new(:source_xml => el)}
        rescue NoMethodError
          self.edits[name] = []
        end
      else
        self.edits[name] ||  (self.source_xml % name).innerHTML
      end
    end

            
    # Returns the name of the object's class ignoring namespacing. 
    # === Use:
    # course = RTunesU::Course.new
    # course.class #=> 'RTunesU::Course'
    # course.class_name #=> 'Course'
    def class_name
      self.class.to_s.split(':').last
    end
    
    # Returns the handle of the entitiy's parent.  This can either be set directly as a string or interger or will access the parent entity.  Sometimes you know the parent_handle without the parent object (for example, stored locally from an earlier request). This allows you to add a new Entity to iTunes U without first firing a reques for a prent entity (For example, if your institution places all inside the same Section, you want to add a new Section to your Site, or a new Group to a course tied to your institution's LMS).
    def parent_handle
      self.parent ? self.parent.handle : @parent_handle
    end
    
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!(self.class_name) {
        self.edits.each {|attribute,edit| edit.is_a?(Array) ? edit.each {|item| item.to_xml(xml_builder)} : xml_builder.tag!(attribute, edit) }
        # self.edits.each {|attribute| xml_builder.tag!(attribute.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }, self.attributes[attribute.to_s]) unless self.attributes[attribute.to_s].nil? || self.attributes[attribute.to_s].empty? }
      }
    end
    
    def update(connection)
      connection.process(Document::Merge.new(self).xml)
      self
    end
    
    def create(connection)
      response = Hpricot.XML(connection.process(Document::Add.new(self).xml))
      raise Exception, response.at('error').innerHTML if response.at('error')
      self.handle = response.at('AddedObjectHandle').innerHTML
      self
    end
    
    # Saves the entity to iTunes U.  Save takes single argument (an iTunes U connection object).  If the entity is unsaved this will create the entity and populate its handle attribte.  If the entity has already been saved it will send the updated data (if any) to iTunes U.
    def save(connection)
      saved? ? update(connection) : create(connection)
    end
    
    def saved?
      self.handle : true ? false
    end
    
    # Deletes the entity from iTunes U.  This cannot be undone.
    def delete(connection)
      response = Hpricot.XML(connection.process(Document::Delete.new(self).xml))
      raise Exception, response.at('error').innerHTML if response.at('error')
      self.handle = nil
      self
    end
  end
  
  class EntityNotFound < Exception
  end
  
  class MissingParent < Exception
  end
end