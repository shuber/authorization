module RightTestHelper
  
  def create_right(options = {})
    Right.create(valid_right_hash(options))
  end
  
  def valid_right_hash(options = {})
    { :name => 'test' }.merge(options)
  end
  
end