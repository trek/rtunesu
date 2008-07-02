module RTunesU
  class User
    attr_accessor :name, :email, :username, :id, :credentials
    
    def initialize(id, username, name, email)
      self.id, self.username, self.name, self.email = id, username, name, email
    end
    
    def to_identity_string
      '"%s" <%s> (%s) [%s]' % [name, email, username, id]
    end
    
    def to_credential_string
      self.credentials.join(';')
    end    
  end
end