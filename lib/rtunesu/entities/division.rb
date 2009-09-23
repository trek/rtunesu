module RTunesU
  # A Division in iTunes U is a seperate nested area of your iTunes U Site.  
  # It is different than a Section which is expressed in iTunes a a seperate area on a single page.
  class Division < Entity
    composed_of :name, :short_name, :identifier, :allow_subscription, :theme_handle, :description
    has_n :permissions, :sections
  end
end