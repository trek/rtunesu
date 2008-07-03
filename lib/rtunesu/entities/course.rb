module RTunesU
  class Course < Entity
    attr_accessor :name, :handle, :instrcutor, :description
    def attributes
      {:name => self.name, :handle => self.handle, :instrcutor => self.instrcutor, :description => self.description}
    end
  end
end