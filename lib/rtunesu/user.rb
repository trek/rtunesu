module RTunesU
  # Represents a User for iTunes U authentication.  Requests to iTunes U require User information in a specific format. This class exists to access data in that specific format.  Best combined with a User object from your own authentication or LMS system.
  # Webservices requests to iTunes U require your institutions administrator credentials
  # === User
  # u = RTunesU::User.new('191912121', 'jsmith', 'John Smith', 'jsmith@exmaple.edu')
  # u.credentials = ['Instructor@urn:mace:example.edu', 'Learner@urn:mace:example.edu']
  # u.to_identity_string #=> '"John Smith" <jsmith@example.edu> (jsmith) [191912121]'
  # u.to_credential_string #=> 'Instructor@urn:mace:example.edu;Learner@urn:mace:example.edu'
  # === Interaction with other classes
  # a User object is required for creating a Connection object
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