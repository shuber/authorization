require File.dirname(__FILE__) + '/init'

class TestController < ActionController::Base
  authorize :right => :test, :only => [:authorize_right]
  authorize :rights => [:test, :test2], :only => [:authorize_rights]
  authorize :rights => [:test, :test2], :role => :test, :only => [:authorize_rights_and_role]
  authorize :role => :test, :only => [:authorize_role]
  
  attr_accessor :current_user
  
  def authorize_right
    render :text => 'test'
  end
  
  def authorize_rights
    render :text => 'test'
  end
  
  def authorize_rights_and_role
    render :text => 'test'
  end
  
  def authorize_role
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
  map.connect 'authorize_rights_and_role', :controller => 'test', :action => 'authorize_rights_and_role'
  map.connect 'authorize_role', :controller => 'test', :action => 'authorize_role'
  map.connect 'no_authorization', :controller => 'test', :action => 'no_authorization'
end

class ControllerTest < Test::Unit::TestCase
  
  def setup
    create_all_tables
    @user_with_rights = create_user_with_rights
    @role = create_role :name => 'test'
    @right = create_right :name => 'test'
    @right2 = create_right :name => 'test2'

    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @controller.instance_variable_set('@_request', @request)
    @controller.instance_variable_set('@_session', @request.session)
    
    @controller.current_user = @user_with_rights
  end
  
  def teardown
    drop_all_tables
  end

  def test_should_authorize_right
    @user_with_rights.role = @role
    @role.rights << @right
    @user_with_rights.save
    
    get :authorize_right
    assert_response :success
  end

  def test_should_not_authorize_right
    get :authorize_right
    assert_response :redirect
  end

  def test_should_authorize_rights
    @user_with_rights.role = @role
    @role.rights << @right
    @role.rights << @right2
    @user_with_rights.save
    
    get :authorize_rights
    assert_response :success
  end

  def test_should_not_authorize_rights
    @user_with_rights.role = @role
    @role.rights << @right
    @user_with_rights.save
    
    get :authorize_rights
    assert_response :redirect
  end

  def test_should_authorize_rights_and_role
    @user_with_rights.role = @role
    @role.rights << @right
    @role.rights << @right2
    @user_with_rights.save
    
    get :authorize_rights_and_role
    assert_response :success
  end

  def test_should_not_authorize_rights_and_role
    @user_with_rights.role = @role
    @role.rights << @right
    @user_with_rights.save
    
    get :authorize_rights_and_role
    assert_response :redirect
  end

  def test_should_authorize_role
    @user_with_rights.role = @role
    @user_with_rights.save
    
    get :authorize_role
    assert_response :success
  end

  def test_should_not_authorize_role
    get :authorize_role
    assert_response :redirect
  end

  def test_should_not_require_authorization
    get :no_authorization
    assert_response :success
  end
  
  def test_authorized_should_yield_nil_if_block_given_and_false
    assert_nil @controller.send(:authorized?, { :role => :test }) { 'some_value' }
  end
  
  def test_authorized_should_yield_block_if_block_given_and_false
    @user_with_rights.role = @role
    @user_with_rights.save
    assert_equal 'some_value', @controller.send(:authorized?, { :role => :test }) { 'some_value' }
  end
  
end