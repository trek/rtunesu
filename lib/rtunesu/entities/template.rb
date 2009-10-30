module RTunesU
  class Tempalte < Entity
    composed_of :name, :handle
    has_n :permissions
  end
end