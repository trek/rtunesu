module RTunesU
  # A Site in iTunes U.
  class Site < Entity
    composed_of :name, :theme_handle, :allow_subscription
    has_n :permissions, :sections, :templates
  end
  
  def delete(connection)
    raise "You cannot delete your entire site"
  end
  
  def create(connection)
    raise "only apple can create a Site for you."
  end
end