module RTunesU
  class Course < Entity
    attributes :handle, :name, :short_name, :identifier, :instructor, :description
    attr_accessor :aggregate_file_size, :group, :permission, :allow_subscription, :theme_handle
  end
end