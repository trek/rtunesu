require 'builder'
require 'xmlsimple'

module RTunesU
  module Document
    class Base
      INDENT = 2
      attr_accessor :builder, :source, :options, :xml
      
      def initialize(source, options = {})
        self.source, self.options = source, options
        builder = Builder::XmlMarkup.new(:indent => INDENT)
        builder.instruct!
        builder.tag!('ITunesUDocument') {
          builder.tag!('Version', RTunesU::API_VERSION)
          self.xml = tag_action(builder)
        }
        self
      end

      # Implemented in each of the subclasses of Document::Base. Adds the particular action you would like to take (AddFoo, MergeFoo, DeleteFoo) to the Source class.
      # For example, if the source Entity is of the type Track and you are creating a Document::Add the ITunesUDocument element will have a child element of <AddTrack>...</AddTrack>
      # tag_action is called from inside Document::Base.new and is based the initializer's builder object so that proper nesting is maintained.
      private
        def tag_action(xml_builder)
          return
        end 
    end
        
    class Add < Base
      private
        def tag_action(xml_builder)
          xml_builder.tag!("Add#{source.class_name}") {
            source.to_xml(xml_builder)
          }
        end
    end
    
    class Merge < Base
      private
        def tag_action(xml_builder)
          xml_builder.tag!("Merge#{source.class_name}") {
            xml_builder.tag!("#{source.class_name}Handle", source.handle)
            source.to_xml(xml_builder)
            # xml_builder.tag!("#{source.class_name}Path")
          }
      end
    end
  
    class Delete < Base
      private
        def tag_action(xml_builder)
          xml_builder.tag!("Delete#{source.class_name}") {
            xml_builder.tag!("#{source.class_name}Handle")
            xml_builder.tag!("#{source.class_name}Path")
          }
        end
    end
    
    # Shows the hierarchy tree for a portion of your iTunes U site.  If the source object has no handle, the tree for your entire site is shown.
    # ShowTree.new can take an option options hash. The possible values for this hash are
    # :key_group.  They iTunes U 'KeyGroup' that defines the amount of data returned from the ShowTree action. Possible values are 'minimal','most','maximal'.  
    class ShowTree < Base
      private
        def tag_action(xml_builder)
          xml_builder.tag!('ShowTree') {
            xml_builder.tag!('Handle', self.source.handle) if self.source.handle
            xml_builder.tag!('KeyGroup', options[:key_group] || 'most')
          }
        end
    end
  end
end