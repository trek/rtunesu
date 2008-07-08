module RTunesU
  class Group < Entity
    Attributes = :handle, :name, :track, :short_name, :allow_subscription, :shared_objects
  end
end