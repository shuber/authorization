require 'huberry/authorization/controller_methods'
require 'huberry/authorization/model_methods'

ActionController::Base.extend Huberry::Authorization::ControllerMethods
ActiveRecord::Base.extend Huberry::Authorization::ModelMethods

$:.unshift File.dirname(__FILE__) + '/lib'