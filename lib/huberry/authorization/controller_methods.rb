module Huberry
	module Authorization
		module ControllerMethods
			def self.extended(base)
				base.class_eval do
					extend ClassMethods
					include InstanceMethods

					cattr_accessor :unauthorized_message, :unauthorized_redirect_path
					self.unauthorized_message = 'Unauthorized'
					self.unauthorized_redirect_path = '/'
					
					helper_method :authorized?
				end
			end
			
			module ClassMethods
				def authorize(options = {})
					before_filter_keys = [:only, :except]
					before_filter_options = options.delete_if { |key, value| before_filter_keys.include? key }
				  before_filter(before_filter_options) { |controller| controller.send :authorize, options }
				end
			end
			
			module InstanceMethods
				protected
					def authorize(options = {})
						unauthorized unless authorized?(options)
					end
				
					def authorized?(options = {})
						rights = (options.has_key? :right ? [options[:right]] : options[:rights]) || []
						roles = (options.has_key? :role ? [options:role] : options[:roles]) || []
						if !send(:current_user).nil? && send(:current_user).has_rights?(rights) && send(:current_user).is_roles?(roles)
							block_given? ? yield : true
						else
							block_given? ? nil : false
						end
					end
				
					def unauthorized
						flash[:error] = self.class.unauthorized_message
						redirect_to respond_to?(self.class.unauthorized_redirect_path) ? send(self.class.unauthorized_redirect_path) : self.class.unauthorized_redirect_path.to_s
						false
					end
			end
		end
	end
end