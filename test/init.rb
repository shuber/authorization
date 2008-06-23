$:.reject! { |path| path.include? 'TextMate' }
require 'test/unit'

# Require and include test helpers
#
Dir[File.join(File.dirname(__FILE__), 'helpers', '*_test_helper.rb')].each do |helper|
  require helper
  /(.*?)_test_helper\.rb/.match File.basename(helper)
  class_name = $1.split('_').collect{ |name| name.downcase.capitalize }.join('') + 'TestHelper'
  Test::Unit::TestCase.send :include, Object.const_get(class_name) if Object.const_defined?(class_name)
end

# Load ActiveRecord
#
require 'rubygems'
gem 'activerecord'
require 'active_record'
ActiveRecord::Base.establish_connection :adapter => 'sqlite3', :dbfile => ':memory:'

# Load ActionPack
#
gem 'actionpack'
require 'action_pack'
require 'action_controller'
require 'action_controller/routing'
require 'action_controller/assertions'
require 'action_controller/test_process'

# Routing
#
class ActionController::Routing::RouteSet
	def append
    yield Mapper.new(self)
    install_helpers
	end
end

# Require the main init.rb for the plugin
#
require File.join(File.dirname(File.dirname(__FILE__)), 'init')

# Models
#
class User < ActiveRecord::Base
end

class UserWithRights < User
	uses_authorization
end

class UserWithoutRights < User
	uses_authorization :include_rights => false
end

class Role < ActiveRecord::Base
	has_and_belongs_to_many :rights
end

class Right < ActiveRecord::Base
	has_and_belongs_to_many :roles
end