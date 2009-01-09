require 'test/unit'
require 'rubygems'

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

# Require the main authorization.rb file for the gem/plugin
#
require File.dirname(__FILE__) + '/../lib/authorization'