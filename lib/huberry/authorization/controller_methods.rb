module Huberry
	module Authorization
		module ControllerMethods			
			def self.extended(base)
				base.class_eval do
					include InstanceMethods

					cattr_accessor :authorization_message, :authorization_redirect_path
					self.authorization_message = 'Unauthorized'
					self.authorization_redirect_path = '/'
				end
			end
			
			module InstanceMethods
			end
		end
	end
end