module RTunesU
  class User
    attr_accessor :name, :email, :username, :id, :credentials
    
    def initialize(id, username, name, email)
      self.id = id
      self.username = username
      self.name = name
      self.email = email
    end
    
    def to_identity_string
      '"%s" <%s> (%s) [%s]' % [name, email, username, id]
    end
    
    def to_credential_string
      self.credentials.join(';')
    end    
  end
end