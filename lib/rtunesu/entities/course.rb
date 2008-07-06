module RTunesU
  class Course < Entity
    attributes :handle, :name, :short_name, :identifier, :instructor, :description
    attr_reader :aggregate_file_size
  end
end