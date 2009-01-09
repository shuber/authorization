require File.dirname(__FILE__) + '/init'

class ModelTest < Test::Unit::TestCase
  
  def setup
    create_all_tables
    @user_with_rights = create_user_with_rights
    @user_without_rights = create_user_without_rights
    @role = create_role :name => 'test'
    @right = create_right :name => 'test'
    @right2 = create_right :name => 'test2'
  end
  
  def teardown
    drop_all_tables
  end

  def test_has_right_for_user_with_rights_should_return_true
    @user_with_rights.role = @role
    @role.rights << @right
    assert @user_with_rights.has_right?(@right.name)
  end

  def test_has_right_for_user_with_rights_should_return_false
    @user_with_rights.role = @role
    assert !@user_with_rights.has_right?(@right.name)
  end

  def test_has_right_for_user_without_rights_should_return_false
    @user_without_rights.role = @role
    assert !@user_without_rights.has_right?(@right.name)
  end
  
  def test_has_right_should_return_true_if_passed_empty_arguments
    assert @user_with_rights.has_rights?([])
  end
  
  def test_has_right_should_return_false_if_role_is_nil
    assert !@user_with_rights.has_right?('test')
    assert !@user_without_rights.has_right?('test')
  end
  
  def test_has_rights_with_multiple_arguments_for_user_with_rights_should_return_true
    @user_with_rights.role = @role
    @role.rights << @right
    @role.rights << @right2
    assert @user_with_rights.has_rights?([@right.name, @right2.name])
  end
  
  def test_has_rights_with_multiple_arguments_for_user_with_rights_should_return_false
    @user_with_rights.role = @role
    @role.rights << @right
    assert !@user_with_rights.has_rights?([@right.name, @right2.name])
  end

  def test_is_role_for_user_with_rights_should_return_true
    @user_with_rights.role = @role
    assert @user_with_rights.is_role?(@role.name)
  end
  
  def test_is_role_for_user_with_rights_should_return_false
    assert !@user_with_rights.is_role?(@role.name)
  end
  
  def test_is_role_for_user_without_rights_should_return_true
    @user_without_rights.role = @role
    assert @user_without_rights.is_role?(@role.name)
  end
  
  def test_is_role_for_user_without_rights_should_return_false
    assert !@user_without_rights.is_role?(@role.name)
  end
  
  def test_is_role_should_return_true_if_argument_is_nil
    assert @user_with_rights.is_role?(nil)
    assert @user_without_rights.is_role?(nil)
  end

end