module RTunesU
  class Entity    
    def class_name
      self.class.to_s.split(':').last
    end
    
    def to_xml(xml_builder)
      xml_builder.tag!(self.class_name) {
        self.attributes.each { |name, value| xml_builder.tag!(name, value) unless value.nil?}
      }
    end
  end
end