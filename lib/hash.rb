class Hash  
  def method_missing(method_name)
    self.fetch(method_name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }, nil)
  end
end