module RTunesU
  class Track < Entity
    Attributes = :handle, :name, :kind, :disc_number, :duration_milliseconds, :albumn_name, :artist_name, :download_url
  end
end