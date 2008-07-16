module RTunesU
  # A Section in iTunes U.  A Section is expressed in the iTunes interface as a visually seperate area on a single page.  This is different than a Division which is a seperate nested area of iTunes U.
  # == Attributes
  # Handle
  # Name
  # AllowSubscription
  # AggregateFileSize (read only)
  # 
  # == Nested Entities
  # Permission
  # Course
  # Division
  class Section < Entity
  end
end