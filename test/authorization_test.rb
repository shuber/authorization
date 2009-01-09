require File.dirname(__FILE__) + '/init'

class AuthorizedUser
  def authorized?(options)
    true
  end
end

class UnauthorizedUser
  def authorized?(options)
    false
  end
end

class AuthorizedUserWithDifferentAuthorizeMethodName
  def authorized?(options)
    false
  end
  
  def different_authorized_method?(options)
    true
  end
end

class TestController < ActionController::Base
  authorize :only => :authorization_required
  authorize :message => 'You are not authorized', :only => :authorization_required_again
  
  attr_accessor :current_user
  attr_accessor :other_object
  
  def authorization_required
    render :text => 'test'
  end
  
  def authorization_required_again
    render :text => 'test'
  end
  
  def authorization_not_required
    render :text => 'test'
  end
  
  def rescue_action(e)
    raise e
  end
end

ORIGINAL_AUTHORIZATION_OPTIONS = TestController.authorization_options.dup

ActionController::Routing::Routes.append do |map|
  map.connect 'authorization_required', :controller => 'test', :action => 'authorization_required'
  map.connect 'authorization_required_again', :controller => 'test', :action => 'authorization_required_again'
  map.authorization_not_required 'authorization_not_required', :controller => 'test', :action => 'authorization_not_required'
end

class AuthorizationTest < Test::Unit::TestCase
  
  def setup
    @controller = TestController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @controller.instance_variable_set('@_request', @request)
    @controller.instance_variable_set('@_session', @request.session)
    
    @controller.class.authorization_options = ORIGINAL_AUTHORIZATION_OPTIONS.dup
  end
  
  def test_should_not_require_authorization
    get :authorization_not_required
    assert_response :success
  end
  
  def test_should_be_unauthorized_for_nil_user
    get :authorization_required
    assert_response :redirect
  end
  
  def test_should_be_unauthorized_for_user
    @controller.current_user = UnauthorizedUser.new
    get :authorization_required
    assert_response :redirect
  end
  
  def test_should_authorize_user
    @controller.current_user = AuthorizedUser.new
    get :authorization_required
    assert_response :success
  end
  
  def test_should_authorize_user_with_a_different_authorize_method_name
    @controller.class.authorization_options[:method] = :different_authorized_method?
    @controller.current_user = AuthorizedUserWithDifferentAuthorizeMethodName.new
    get :authorization_required
    assert_response :success
  end

  def test_should_redirect_to_the_redirect_to_option
    get :authorization_required
    assert_redirected_to @controller.class.authorization_options[:redirect_to]
  end
  
  def test_should_set_the_flash_to_the_message_option
    get :authorization_required
    assert_equal @controller.class.authorization_options[:message], flash[:error]
  end
  
  def test_should_not_set_the_flash_if_the_message_option_is_false
    @controller.class.authorization_options[:message] = false
    get :authorization_required
    assert_nil flash[@controller.class.authorization_options[:flash_type]]
  end
  
  def test_should_set_the_flash_type_to_the_flash_type_option
    @controller.class.authorization_options[:flash_type] = :notice
    get :authorization_required
    assert_equal @controller.class.authorization_options[:message], flash[:notice]
  end
  
  def test_should_authorize_the_object_passed_as_the_object_option
    @controller.current_user = AuthorizedUser.new
    @controller.other_object = UnauthorizedUser.new
    @controller.class.authorization_options[:object] = :other_object
    get :authorization_required
    assert_response :redirect
  end
  
  def test_should_evaluate_a_symbol_as_an_unauthorized_redirect_path
    @controller.class.authorization_options[:redirect_to] = :authorization_not_required_path
    get :authorization_required
    assert_redirected_to '/authorization_not_required'
  end
  
  def test_authorized_method
    assert !@controller.send(:authorized?)
    
    @controller.current_user = AuthorizedUser.new
    assert @controller.send(:authorized?)
    
    @controller.current_user = UnauthorizedUser.new
    assert !@controller.send(:authorized?)
  end
  
  def test_should_be_able_to_overwrite_default_options
    get :authorization_required_again
    assert_equal 'You are not authorized', flash[:error]
  end
  
end