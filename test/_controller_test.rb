require File.dirname(__FILE__) + '/init'

class User < ActiveRecord::Base
	uses_authorization
end

class TestController < ActionController::Base
	def rescue_action(e)
		raise e
	end
end

ActionController::Routing::Routes.append do |map|
	map.connect '', :controller => 'test', :action => ''
	map.connect '', :controller => 'test', :action => ''
end

class ControllerTest < Test::Unit::TestCase
	
	def setup
    create_users_table
		@user = create_user

		@controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

		@controller.instance_variable_set('@_request', @request)
		@controller.instance_variable_set('@_session', @request.session)
  end
  
  def teardown
    drop_all_tables
  end
	
end