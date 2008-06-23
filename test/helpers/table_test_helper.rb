module TableTestHelper
  
	def create_all_tables
		create_rights_table
		create_rights_roles_table
		create_roles_table
		create_roles_users_table
		create_users_table
	end

  def create_rights_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :rights do |t|
          t.string   :name
        end
      end
    end
  end

	def create_rights_roles_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :rights_roles, :id => false do |t|
          t.integer	 :right_id
					t.integer	 :role_id
        end
      end
    end
  end

	def create_roles_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :roles do |t|
          t.string   :name
        end
      end
    end
  end

	def create_roles_users_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :roles_users do |t|
          t.integer	 :role_id
					t.integer	 :user_id
        end
      end
    end
  end

	def create_users_table
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define(:version => 1) do
        create_table :users do |t|
					t.integer	 :role_id
          t.string   :email
        end
      end
    end
  end
  
  def drop_all_tables
    ActiveRecord::Base.connection.tables.each do |table|
      drop_table(table)
    end
  end
  
  def drop_table(table)
    ActiveRecord::Base.connection.drop_table(table)
  end
  
end