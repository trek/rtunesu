$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rtunesu/version'
require 'rtunesu/connection'
require 'rtunesu/user'
require 'rtunesu/document'
require 'rtunesu/entity'
require 'multipart'

module  RTunesU
  API_URL = 'https://deimos.apple.com/WebObjects/Core.woa/API'
  API_VERSION = '1.1.1'
  BROWSE_URL = 'https://deimos.apple.com/WebObjects/Core.woa/Browse'
end