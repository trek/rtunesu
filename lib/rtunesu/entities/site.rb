module RTunesU
  # Site represents an entire iTunes U site representing an institution.  Each Site can have one more sections contained inside.
  class Site < Entity
    Attributes = :name
    
    # Each authentcaited WS user can only find a single Site. There is no need to provide a specific handle (even if you know the handle for your institution).  
    # Calling Site.find(connection) can take a long time. iTunes U currently will return the entire site tree as xml.  There is no way to obtain site information without also obtaining information for some child elements contained inside the Site. It is reccomended that you store your institution's handle externally (as it is unlikely to change) for updating site-wide information (like name, access, permissions)
    def self.find(connection)
      super(nil, connection)
    end
  end
end