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
          authorize_options, before_filter_options = {}, {}
          options.each { |key, value| (before_filter_keys.include?(key) ? before_filter_options : authorize_options)[key] = value }
          before_filter(before_filter_options) { |controller| controller.send :authorize, authorize_options }
        end
      end
      
      module InstanceMethods
        protected
          def authorize(options = {})
            unauthorized unless authorized?(options)
          end
        
          def authorized?(options = {})
            options[:user] ||= :current_user
            user = options[:user].is_a?(Symbol) ? send(options[:user]) : options[:user]
            rights = (options.has_key?(:right) ? [options[:right]] : options[:rights]) || []
            role = options[:role]
            if !user.nil? && user.has_rights?(rights) && user.is_role?(role)
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