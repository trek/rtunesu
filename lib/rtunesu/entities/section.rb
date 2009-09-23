module RTunesU
  # A Section in iTunes U.  A Section is expressed in the iTunes interface as a visually 
  # seperate area on a single page.  This is different than a Division which is a 
  # seperate nested area of iTunes U.
  class Section < Entity
    composed_of :name
    has_n :courses
  end
end