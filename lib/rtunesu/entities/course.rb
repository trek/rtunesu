module RTunesU
  # A Course in iTunes U.

  # ? LinkedFolderHandle
  class Course < Entity
    composed_of :name, :instructor, :description, :identifier, :theme_handle, :short_name, :allow_subscription
    composed_of :aggregate_file_size, :readonly => true
    has_n :permissions, :groups
  end
end