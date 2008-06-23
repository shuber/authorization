module RoleTestHelper
  
  def create_role(options = {})
    Role.create(valid_role_hash(options))
  end
  
  def valid_role_hash(options = {})
    { :name => 'test' }.merge(options)
  end
  
end