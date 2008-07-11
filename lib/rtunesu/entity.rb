require 'hpricot'

module RTunesU
  class Entity
    attr_accessor :connection, :attributes, :handle, :parent, :parent_handle, :saved, :source_xml
    
    def initialize(attrs = {})
      self.attributes = {}
      attrs.each {|attribute, value| self.send("#{attribute}=", value)}
    end
    
    def self.find(handle, connection)
      entity = self.new(:handle => handle)
      entity.load_from_xml(connection.process(Document::ShowTree.new(entity).xml))
      entity
    end
        
    def load_from_xml(xml)
      self.source_xml = Hpricot.XML(xml).at("//ITunesUResponse//#{self.class_name}//Handle[text()=#{self.handle}]..")
      raise EntityNotFound if self.source_xml.nil?
    end
    
    # Edits stores the changes made to an object
    def edits
      @edits ||= {}
    end
    
    def reload
      self.edits.clear
    end
    
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
    # course = RTunesU::Course.new
    # course.class #=> 'RTunesU::Course'
    # course.class_name #=> 'Course'
    def class_name
      self.class.to_s.split(':').last
    end
    
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
      response = XmlSimple.xml_in(connection.process(Document::Add.new(self).xml), 'ForceArray' => false)
      raise Exception, response['error'] if response.has_key?('error')
      self.handle = response['AddedObjectHandle']
      self
    end
    
    def save(connection)
      saved? ? update(connection) : create(connection)
    end
    
    def saved?
      !self.handle.nil?
    end
    
    def delete(connection)
      connection.process(Document::Delete.new(self).xml)
    end
  end
  
  class EntityNotFound < Exception
  end
end