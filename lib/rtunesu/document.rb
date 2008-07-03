require 'builder'
require 'xmlsimple'

module RTunesU
  module Document
    class Base
      INDENT = 2
      attr_accessor :builder, :source
      
      def initialize(source)
        self.source = source
        self.builder = Builder::XmlMarkup.new(:indent => INDENT)
        builder.instruct!
        builder.tag!('ITunesUDocument') {
          builder.tag!('Version', RTunesU::API_VERSION)
          tag_action(builder)
        }
      end
      
      def tag_action(xml_builder)
        return
      end 
    end
    
    class ShowTree < Base
      def tag_action(xml_builder)
        xml_builder.tag!('ShowTree') {
          xml_builder.tag!('KeyGroup', 'maximal')
        }
      end
    end
    
    class Create < Base
      def tag_action(xml_builder)
        xml_builder.tag!("Add#{source.class_name}") {
          source.to_xml(builder)
        }
      end
    end
  end
end