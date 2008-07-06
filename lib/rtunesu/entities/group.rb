module RTunesU
  class Group < Entity
    Attributes = :handle, :name, :track, :short_name, :external_feed, :group_type, :permission, :allow_subscription, :shared_objects
  end
end