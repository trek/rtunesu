module RTunesU
  class Entity
    attr_accessor :connection
    
    def initialize(attrs)
      attrs.each {|attribute, value| self.send("#{attribute}=", value)}
    end
    
    def self.find(handle, connection)
      entity = self.new(:handle => handle)
      entity.load_from_xml(connection.process(Document::ShowTree.new(entity).xml))
    end
    
    def load_from_xml(xml)
      XmlSimple.xml_in(xml, 'ForceArray' => false)['Site'][self.class_name]
    end
    
    # 'attributes' are a specific type of instance data that is accessible with either the getter methods or through the attributes hash.  Only data listed as an 'attribute' will serialize to xml when saving to iTunes U.  This allows Entity objects to have local data that will not be send to iTunes U
    # 'attributes' are listed at the beginning of a class defintion and define setters, getters, and the attributes hash.
    # For example, 
    # class Thing
    #   attributes :name, :size
    # end
    # 
    # will create a new class with the methods .name, .name=, .size, .size= and .attributes. The attributes method will return a hash with keys of :name and :size whose values are the instance data for name and size.
    # So
    # thing = Thing.new(:name => 'coffee cup', :size => 'large')
    # thing.name #=> 'coffee cup'
    # thing.size #=> 'large'
    # thing.size=('small') #=> sets @size to small
    # thing.attributes #=> {:name => 'coffee cup', :size => 'small'}
    def self.attributes(*attrs)
      attr_accessor *attrs
      define_method :attributes do
        h = {}
        attrs.each {|attribute| h[attribute] = self.send(attribute)}
        @attributes ||= h
      end
    end
            
    # Returns the name of the object's class ignoring namespacing. 
    # course = RTunesU::Course.new
    # course.class #=> 'RTunesU::Course'
    # course.class_name #=> 'Course'
    def class_name
      self.class.to_s.split(':').last
    end
    
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!(self.class_name) {
        self.attributes.each { |name, value| xml_builder.tag!(name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }, value) unless value.nil?}
      }
    end
  end
end