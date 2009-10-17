$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'hpricot'
require 'activesupport'

require 'rtunesu/version'
require 'rtunesu/connection'
require 'rtunesu/user'
require 'rtunesu/document'
require 'rtunesu/entity'
require 'rtunesu/entities/course'
require 'rtunesu/entities/division'
require 'rtunesu/entities/external_feed'
require 'rtunesu/entities/group'
require 'rtunesu/entities/permission'
require 'rtunesu/entities/section'
require 'rtunesu/entities/site'
require 'rtunesu/entities/track'
require 'rtunesu/entities/theme'
require 'rtunesu/log'
require 'rtunesu/subentities'

module  RTunesU
  API_URL = 'https://deimos.apple.com/WebObjects/Core.woa/API'.freeze
  API_VERSION = '1.1.3'.freeze
  BROWSE_URL = 'https://deimos.apple.com/WebObjects/Core.woa/Browse'.freeze
  SHOW_TREE_URL = 'https://deimos.apple.com/WebObjects/Core.woa/API/ShowTree'.freeze
  
  SHOW_TREE_FILE = File.new(File.join(File.dirname(__FILE__), 'show_tree.xml'))

end