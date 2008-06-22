require 'digest/sha2'

module Huberry
	module Authorization
		module ModelMethods
			def uses_authorization(options = {})
				include InstanceMethods
			end
		end
		
		module InstanceMethods
			def has_rights?(rights)
			end
			alias_method :has_right?, :has_rights?
			
			def is_roles?(roles)
			end
			alias_method :is_role?, :is_roles?
		end
	end
end