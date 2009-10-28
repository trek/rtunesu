module RTunesU
  module VERSION #:nodoc:
    STRING = File.read(File.join(File.dirname(__FILE__), '../../VERSION')).strip!.freeze
  end
end
