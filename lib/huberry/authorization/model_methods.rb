require 'digest/sha2'

module Huberry
	module Authorization
		module ModelMethods
			def uses_authorization(options = {})
				extend ClassMethods
				include InstanceMethods
			end
		end
		
		module ClassMethods
		end
		
		module InstanceMethods
		end
	end
end