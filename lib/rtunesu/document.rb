require 'builder'

module RTunesU
  # Document is a class for generating the neccessary XML to interact with iTunes U.
  # Documents are generated and sent when calling .save, .create, .update, and .delete on
  # specific Entity instances.  Classes in the Document:: namespace aren't intended for direct use.
  # For example:
  # c = Course.find(12345, itunes_connection_object)
  # c.Name # "Exemple Course"
  # c.Name = 'Example Course'
  # c.save(itunes_connection_object) # genertes and sends a Document::Merge object with the Course data.
  module Document # :nodoc:
    class Base
      INDENT = 2
      attr_accessor :builder, :source, :options, :xml
      
      # Creates a new XML document using Builder.  Includes the required XML entities of 
      # ITunesUDocument and Version, then calls tag_action to add in specific XML entities for
      # the type of document being built. tag_action is defined in each sublcass of Document.
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

      # Implemented in each of the subclasses of Document::Base. Adds the particular action you would 
      # like to take (AddFoo, MergeFoo, DeleteFoo) to the Source class.
      # For example, if the source Entity is of the type Track and you are creating a 
      # Document::Add the ITunesUDocument element will have a child element of <AddTrack>...</AddTrack>
      # tag_action is called from inside Document::Base.new and is based the initializer's builder
      # object so that proper nesting is maintained.
      private
        def tag_action(xml_builder)
          return
        end 
    end
      
    # Creates an XML document that comforms to iTunes U's specification for adding an entity. 
    # This class is used internally by Entity classes when saving.
    class Add < Base
      private
        def tag_action(xml_builder)
          raise MissingParent if source.parent_handle.nil?
          xml_builder.tag!("Add#{source.class_name}") {
            xml_builder.tag!('ParentHandle', source.parent_handle)
            # The existance of ParentPath is required for iTunesU documents, but can be blank
            xml_builder.tag!('ParentPath', '')
            source.to_xml(xml_builder)
          }
        end
    end
        
    # Creates an XML document that comforms to iTunes U's specification for updating an entity.
    # This class is used internally by Entity classes when saving.
    class Merge < Base
      private
        def tag_action(xml_builder)
          xml_builder.tag!("Merge#{source.class_name}") {
            xml_builder.tag!("#{source.class_name}Handle", source.handle)
            source.to_xml(xml_builder)
          }
      end
    end
  
    # Creates an XML document that comforms to iTunes U's specification for deleting an entity.
    # This class is used internally by Entity classes when saving.
    class Delete < Base
      private
        def tag_action(xml_builder)
          xml_builder.tag!("Delete#{source.class_name}") {
            xml_builder.tag!("#{source.class_name}Handle", source.handle)
            xml_builder.tag!("#{source.class_name}Path", '') unless source.class_name == 'Track'
          }
        end
    end
  end
end