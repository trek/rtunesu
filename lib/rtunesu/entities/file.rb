module RTunesU
  class File < Entity
    composed_of :name, :path, :shared
    composed_of :size, :readonly => true
  end
end