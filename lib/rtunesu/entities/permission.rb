module RTunesU
  # A Permission in iTunes U.
  class Permission < Entity
    composed_of :credential, :access
  end
end