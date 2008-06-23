module Huberry
	module Authorization
		module ModelMethods
			def uses_authorization(options = {})
				include InstanceMethods
				
				default_options = {
					:include_rights => true,
					:rights_association_name => :rights,
					:right_name_field => :name,
					:role_association_name => :role,
					:role_name_field => :name
				}
				default_options.merge!(options)
				
				if default_options[:include_rights]
					belongs_to default_options[:role_association_name], :include => default_options[:rights_association_name]
				else
					belongs_to default_options[:role_association_name]
				end
				
				# cattr_reader :authorization_options
				class << self; attr_reader :authorization_options; end
				@authorization_options = default_options
			end
		end
		
		module InstanceMethods
			def has_rights?(right_names)
				return true if right_names.empty? || self.class.authorization_options[:include_rights].nil?
				
				right_names = [right_names] unless right_names.is_a? Array
				role_association = send(self.class.authorization_options[:role_association_name])
				return false if role_association.nil?
				
				rights_association = role_association.send(self.class.authorization_options[:rights_association_name])
				right_names.all? { |right_name| rights_association.collect(&self.class.authorization_options[:right_name_field]).include?(right_name.to_s) }
			end
			alias_method :has_right?, :has_rights?
			
			def is_role?(role_name)
				return true if role_name.nil?
				role_association = send(self.class.authorization_options[:role_association_name])
				!role_association.nil? && role_association.send(self.class.authorization_options[:role_name_field]) == role_name.to_s
			end
		end
	end
end