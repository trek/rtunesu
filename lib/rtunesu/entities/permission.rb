module RTunesU
  # A Permission in iTunes U.
  # == Attributes
  # Credential
  # Access
  # 
  # == Nested Entities
  class Permission < Entity
    composed_of :credential, :access
  end
end