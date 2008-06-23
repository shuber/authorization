require File.dirname(__FILE__) + '/init'

class User < ActiveRecord::Base
	uses_authorization
end

class TestController < ActionController::Base
	authorize :right => :test, :only => [:authorize_right]
	authorize :rights => [:test, :test2], :only => [:authorize_rights]
	authorize :rights => [:test, :test2], :roles => [:test, :test2], :only => [:authorize_rights_and_roles]
	authorize :role => :test, :only => [:authorize_role]
	authorize :roles => [:test, :test2], :only => [:authorize_roles]
	
	attr_accessor :current_user
	
	def authorize_right
		render :text => 'test'
	end
	
	def authorize_rights
		render :text => 'test'
	end
	
	def authorize_rights_and_roles
		render :text => 'test'
	end
	
	def authorize_role
		render :text => 'test'
	end
	
	def authorize_roles
		render :text => 'test'
	end
	
	def no_authorization
		render :text => 'test'
	end
	
	def rescue_action(e)
		raise e
	end
end

ActionController::Routing::Routes.append do |map|
	map.connect 'authorize_right', :controller => 'test', :action => 'authorize_right'
	map.connect 'authorize_rights', :controller => 'test', :action => 'authorize_rights'
	map.connect 'authorize_rights_and_roles', :controller => 'test', :action => 'authorize_rights_and_roles'
	map.connect 'authorize_role', :controller => 'test', :action => 'authorize_role'
	map.connect 'authorize_roles', :controller => 'test', :action => 'authorize_roles'
	map.connect 'no_authorization', :controller => 'test', :action => 'no_authorization'
end

class ControllerTest < Test::Unit::TestCase
	
	def setup
    create_all_tables
		@user = create_user
		@role = create_role :name => 'test'
		@role2 = create_role :name => 'test2'
		@right = create_right :name => 'test'
		@right2 = create_right :name => 'test2'

		@controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

		@controller.instance_variable_set('@_request', @request)
		@controller.instance_variable_set('@_session', @request.session)
		@controller.current_user = @user
  end
  
  def teardown
    drop_all_tables
  end

	def test_should_authorize_right
	  assert false
	end

	def test_should_not_authorize_right
	  assert false
	end

	def test_should_authorize_rights
	  assert false
	end

	def test_should_not_authorize_rights
	  assert false
	end

	def test_should_authorize_rights_and_roles
	  assert false
	end

	def test_should_not_authorize_rights_and_roles
	  assert false
	end

	def test_should_authorize_role
	  assert false
	end

	def test_should_not_authorize_role
	  assert false
	end

	def test_should_authorize_roles
	  assert false
	end

	def test_should_not_authorize_roles
	  assert false
	end

	def test_should_not_require_authorization
	  assert false
	end
	
end