module RTunesU
  # A Group in iTunes U. A Group is expressed as a tab in the iTunes interface.
  
  class Group < Entity
    ACCESS = {
      :no_access => "No Access",
      :steaming  => "Streaming",
      :download  => "Download",
      :drop_box  => "Drop Box",
      :shared    => "Shared",
      :edit      => "Edit"
    }
    composed_of :name, :group_type, :short_name, :allow_subscription, :explicit
    composed_of :aggregate_file_size, :readonly => true
    validates! :group_type, [:simple, :smart, :feed]
    has_a :external_feed
    has_n :permissions, :tracks, :shared_objects
    
  end
end