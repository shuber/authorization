module UserTestHelper
  
  def create_user(options = {})
    User.create(valid_user_hash(options))
  end

  def create_user_with_rights(options = {})
    UserWithRights.create(valid_user_hash(options))
  end
  
  def create_user_without_rights(options = {})
    UserWithoutRights.create(valid_user_hash(options))
  end
  
  def valid_user_hash(options = {})
    { :email => 'test@test.com' }.merge(options)
  end
  
end