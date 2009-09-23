module RTunesU
  # A Site in iTunes U.
  # == Attributes
  # Name
  # Handle
  # AllowSubscription
  # AggregateFileSize
  # ThemeHandle
  # LoginURL
  
  # == Nested Entities
  # Permission
  # Theme
  # LinkCollectionSet
  # Section
  class Site < Entity
    composed_of :name, :theme_handle, :allow_subscription
    has_n :permissions, :sections, :templates
  end
end