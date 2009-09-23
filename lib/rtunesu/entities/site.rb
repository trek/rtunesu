module RTunesU
  # A Site in iTunes U.
  class Site < Entity
    composed_of :name, :theme_handle, :allow_subscription
    has_n :permissions, :sections, :templates
  end
end