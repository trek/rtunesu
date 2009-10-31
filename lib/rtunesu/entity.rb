module RTunesU
  # http://deimos.apple.com/rsrc/xsd/iTunesURequest-1.1.3.xsd
  # A Base class reprenseting the various entities seen in iTunes U.  Subclassed into the actual entity 
  # classes (Course, Division, Track, etc).  Entity is mostly an object oriented interface to the 
  # underlying XML data returned from iTunes U.  Most attributes of an Entity are read by searching
  # the souce XML returned from iTunes U
  # == Reading and Writing Attributes
  # c = Course.find(12345, rtunes_connection_object) # finds the Course in iTunes U and stores its XML data
  # c.handle # finds the <Handle> element in the XML data and returns its value (in this case 12345)
  # c.name   # finds the <Name> element in the XML data and returns its value (e.g. 'My Example Course')
  # c.name = 'Podcasting: a Revolution' # writes a hash of unsaved data that will be sent to iTunes U.
  #
  # == Accessing related entities 
  # Related Entity objects are accessed with the pluralized form of their class name.  
  # To access a Course's related Group entities, you would use c.groups. This will return an array of 
  # Group objects (or an empty Array object if there are no associated Groups)
  # You can set the array of associated entities by using the '=' form of the accessor and add another 
  # element to the end of an array of related entities with '<<'
  # Examples:
  # c = Course.find(12345, rtunes_connection_object) # finds the Course in iTunes U and stores its XML data
  # c.groups # returns an array of Group entities or an empty array of there are no Group entities
  # c.groups = [Group.new(:name => 'Lectures')] # assigns the Groups related entity array to an existing 
  # array (overwriting any local data about Groups)
  # c.groups << Group.new(:name => 'Videos') # Adds the new Group object to the end of hte Groups array
  # c.groups.collect {|g| g.name} # ['Lectures', 'Videos']
  class Entity
    attr_accessor :connection, :parent, :parent_handle, :saved, :source_xml
    attr_reader :handle
    
    def self.attributes
      @attributes ||= Set.new
    end
    
    def self.get_base_connection # :nodoc:
      @base_connection
    end
    
    def self.base_connection 
      Entity.get_base_connection
    end
    
    def self.set_base_connection(connection)
      @base_connection = connection
    end
    
    def self.base_connection=(connection)
      self.set_base_connection(connection)
    end
    
    def self.validates!(name, values)
      return
    end
    
    def self.composed_of(*names)
      options = names.extract_options!
      self.attributes.merge(names)
      names.each do |name|
        storage_name = options[:as] || name.to_s.camelize
        
        define_method(name) do
          value_from_edits_or_store(storage_name)
        end
        
        unless options[:readonly]
          define_method(:"#{name}=") do |arg|
            edits[storage_name] = arg
          end
        end
      end
    end
    
    def self.has_a(*names)
      options = names.extract_options!
      self.attributes.merge(names)
      names.each do |name|
        define_method(name) do
          entity_name = options[:as] || name.to_s.camelize
          instance_variable_get("@#{name}") || instance_variable_set("@#{name}", RTunesU::HasAEntityCollectionProxy.new(self.source_xml./(entity_name), self, entity_name))
        end
        
        unless options[:readonly]
          define_method(:"#{name}=") do |arg|
            edits[options[:as] || name.to_s.camelize] = arg
          end
        end
      end
    end
    
    def self.has_n(*names)
      options = names.extract_options!
      self.attributes.merge(names)
      names.each do |name|
        define_method(name) do
          entity_name = options[:as] || name.to_s.chop.camelize
          instance_variable_get("@#{name}") || instance_variable_set("@#{name}", RTunesU::HasNEntityCollectionProxy.new(self.source_xml./(entity_name), self, entity_name))
        end
        
        unless options[:readonly]
          define_method(:"#{name}=") do |arg|
            edits[options[:as] || name.to.camelize] = arg
          end
        end
      end
    end
    
    # Creates a new Entity object with attributes based on the hash argument  Some of these attributes 
    # are assgined to instance variables of the obect (if there is an attr_accessor for it), the rest 
    # will be written to a hash of edits that will be saved to iTunes U using method_missing
    def initialize(attrs = {})
      attrs.each {|attribute, value| self.send("#{attribute}=", value)}
      self.source_xml ||= Hpricot.XML('')
    end
       
    def handle
      @handle ||= handle_from_source
    end
    alias :id :handle
    
    def handle_from_source
      return nil unless self.source_xml
      if (handle_elem = self.source_xml % 'Handle')
        handle_elem.innerHTML
      else
        nil
      end
    end
    
    # Edits stores the changes made to an entity
    def edits
      @edits ||= {}
    end
    
    def edited?
      self.edits.any?
    end
    
    # Clear the edits and restores the loaded object to its original form
    def reload
      self.edits.clear
      self
    end
    
    # Returns the parent of the entity
    def parent
      @parent ||= Object.module_eval(self.source_xml.parent.name).new(:source_xml => self.source_xml.parent)
    rescue
      nil
    end
    
    def value_from_edits_or_store(name)
      self.edits[name] ||  (self.source_xml % name).innerHTML
    rescue NoMethodError
      nil
    end
    
    
    # Returns the name of the object's class ignoring namespacing. 
    # === Use:
    # course = RTunesU::Course.new
    # course.class #=> 'RTunesU::Course'
    # course.class_name #=> 'Course'
    def class_name
      self.class.to_s.split('::').last
    end
    
    def base_connection
      self.class.base_connection
    end
    
    # Returns the handle of the entitiy's parent.  This can either be set directly as a string or interger or 
    # will access the parent entity.  Sometimes you know the parent_handle without the parent object 
    # (for example, stored locally from an earlier request). This allows you to add a new Entity to iTunes U 
    # without first firing a request for a parent entity (For example, if your institution places all courses inside the 
    # same Section, you want to add a new Section to your Site, or a new Group to a course tied to your 
    # institution's LMS).
    def parent_handle
      self.parent ? self.parent.handle : @parent_handle
    end
    
    # Converts the entities changed attributes and subentities to XML.  Called by Document when building
    # documents to transfer to iTunes U.
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!(self.class_name) {
        self.edits.each do |attribute,edit|
          edit.is_a?(SubentityAssociationProxy) ? edit.to_xml(xml_builder) : xml_builder.tag!(attribute, edit)
        end
      }
    end
    
    def inspect
      inspected = "#<#{self.class.to_s} handle:#{@handle.inspect} "
      self.class.attributes.each do |attribute|
        inspected << "#{attribute}:#{self.send(attribute).inspect} "
      end
      inspected   << '>'
    end
  end
  
  class CannotSave < StandardError
  end
  
  class ConnectionRequired < StandardError
  end
  
  class EntityNotFound < StandardError
  end
  
  class MissingParent < StandardError
  end
end