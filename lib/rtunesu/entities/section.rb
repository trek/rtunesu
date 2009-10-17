module RTunesU
  # A Section in iTunes U.  A Section is expressed in the iTunes interface as a visually 
  # seperate area on a single page.  This is different than a Division which is a 
  # seperate nested area of iTunes U.
  class Section < Entity
    composed_of :name
    has_n :courses
    
    # Sections have additional required attributes for updating. These attributes *must* appear
    # in a specific order.
    # see http://deimos.apple.com/rsrc/doc/iTunesUAdministratorsGuide/iTunesUWebServices/chapter_17_section_12.html
    def to_xml(xml_builder = Builder::XmlMarkup.new)
      xml_builder.tag!("SectionPath", '')
      xml_builder.tag!("MergeByHandle", "false")
      xml_builder.tag!("Destructive", "false")
      super
    end
  end
end