module RTunesU
  class Track < Entity
    attributes :handle, :name, :kind, :disc_number, :duration_milliseconds, :albumn_name, :artist_name, :download_url
  end
end