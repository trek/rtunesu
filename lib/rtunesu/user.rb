module RTunesU
  # Represents an User for iTunes U authentication.  iTunes U requires User information in a specific format. This class exists to access data in that specific format.  Best combined with a User object from your local applcation.
  # === Useage
  # u = RTunesU::User.new('191912121', 'jsmith', 'John Smith', 'jsmith@exmaple.edu')
  # u.credentials = ['Instructor@urn:mace:example.edu', 'Learner@urn:mace:example.edu']
  # u.to_identity_string #=> '"John Smith" <jsmith@example.edu> (jsmith) [191912121]'
  # u.to_credential_string #=> 'Instructor@urn:mace:example.edu;Learner@urn:mace:example.edu'
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