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
          builder.tag!(self.class.to_s.split(':').last) {
            tag_inner_elements(builder)
          }
        }
      end
      
      # Implement this method in each subclass of Base
      def tag_inner_elements(xml_builder)
        return
      end
      
    end
    
    class ShowTree < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('KeyGroup', 'maximal')
      end
    end
    
    class MergeSite < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('SiteHandle', 12342323232)
      end
    end
    
    class AddDivision < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/iTunesU/English/10')
      end
    end
  
    class DeleteDivision < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('DivisionHandle', 1234567)
        xml_builder.tag!('DivisionPath', '/foo/bar/baz/')
      end
    end
    
    class MergeDivision < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('SiteHandle', 123456)
      end
    end
    
    class AddSection < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
    
    class DeleteSection < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('SectionHandle', 1234567)
        xml_builder.tag!('SectionPath', '/foo/bar')
      end
    end
    
    class MergeSection < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('SectionHandle', 1234567)
        xml_builder.tag!('SectionPath', '/foo/bar')
      end
    end
    
    class AddCourse < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
    
    class DeleteCourse < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('CourseHandle', 1234567)
        xml_builder.tag!('CoursePath', '/foo/bar')
      end
    end
    
    class MergeCourse < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('CourseHandle', 1234567)
        xml_builder.tag!('CoursePath', '/foo/bar')
      end
    end
    
    class AddGroup < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
    
    class DeleteGroup < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('GroupHandle', 1234567)
        xml_builder.tag!('GroupPath', '/foo/bar')
      end
    end
    
    class MergeGroup < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('GroupHandle', 1234567)
        xml_builder.tag!('GroupPath', '/foo/bar')
      end
    end
    
    class UpdateGroup < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('GroupHandle', 1234567)
        xml_builder.tag!('GroupPath', '/foo/bar')
      end
    end
    
    class AddTrack < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
    
    class DeleteTrack < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('TrackHandle', 1234567)
        xml_builder.tag!('TrackPath', '/foo/bar')
      end
    end
    
    class MergeTrack < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('TrackHandle', 1234567)
        xml_builder.tag!('TrackPath', '/foo/bar')
      end
    end
    
    class AddPermission < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
    
    class DeletePermission < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
    
    class MergePermission < Base
      def tag_inner_elements(xml_builder)
        xml_builder.tag!('ParentHandle', 1234567)
        xml_builder.tag!('ParentPath', '/foo/bar')
      end
    end
  end
end