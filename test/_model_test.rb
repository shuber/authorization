require File.dirname(__FILE__) + '/init'

class User < ActiveRecord::Base
	uses_authorization
end

class ModelTest < Test::Unit::TestCase
  
  def setup
    create_all_tables
  end
  
  def teardown
    drop_all_tables
  end

end