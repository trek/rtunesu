module RTunesU
  class SubentityAssociationProxy
    delegate :inspect, :to => :target
    def initialize(source_xml, owner, name)
      @source_xml = source_xml
      @owner = owner
      @owner.edits[name] = self
      @edits = []
    end
    
  end
  
  class HasAEntityCollectionProxy < SubentityAssociationProxy
    delegate :class, :to => :target
    attr_reader :target
    
    def self.new_or_nil(source_xml, owner, name)
      return nil if source_xml.empty?
      proxy = self.new(source_xml, owner, name)
      proxy.from_xml(name)
      return proxy
    end
    
    def self.new_from_target(target, owner, name)
      proxy = self.new(nil, owner, name)
      proxy.instance_variable_set("@target", target)
      return proxy
    end
    
    def from_xml(name)
      if @source_xml
       @target = "RTunesU::#{name}".constantize.new(:source_xml => @source_xml.first, :parent_handle => @owner.handle)
      else
       @target = "RTunesU::#{name}".constantize.new(:parent_handle => @owner.handle)
      end
    end
    
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      @target.to_xml(xml_builder) if @target.edits.any?
    end
    
    def method_missing(method_name, *args)
      @target.send(method_name, args)
    end
  end
  
  class HasNEntityCollectionProxy < SubentityAssociationProxy
    delegate :[], :at, :first, :last, :size, :clear, :to => :target
    attr_reader :target, :edits
    
    def initialize(source_xml, owner, name)
      super
      self.from_xml(name)
    end

    def from_xml(name)
      if @source_xml
       @target = @source_xml.collect {|el| "RTunesU::#{name}".constantize.new(:source_xml => el, :parent_handle => @owner.handle)}
      else
       @target = []
      end
    end
    
    def to_xml(builder)
      self.edits.each {|entity| entity.to_xml(builder)}
    end
    
    def <<(entity)
      @target << entity
      @edits  << entity
    end
    
    def []=(index,entity)
      @target[index] = entity
      @entity[index] = entity
    end
  end
end