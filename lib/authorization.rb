module Huberry
  module Authorization
    def self.extended(base)
      base.class_eval do
        include InstanceMethods
        
        cattr_accessor :authorization_options
        self.authorization_options = {
          :flash_type => :error, 
          :message => 'Unauthorized', 
          :method => :authorized?, 
          :object => :current_user, 
          :redirect_to => '/'
        }
        
        helper_method :authorized?
      end
    end
  
    protected
  
      def authorize(options = {})
        before_filter_options = options.reject { |key, value| ![:only, :except, :if, :unless].include?(key) }
        before_filter(before_filter_options) { |controller| controller.send :authorize, options }
      end
  
    module InstanceMethods
      protected
        def authorize(options = {})
          unauthorized(options) unless authorized?(options)
        end
        
        def authorized?(options = {})
          options = self.class.authorization_options.merge(options)
          object = case options[:object]
          when Symbol
            send(options[:object])
          when Proc
            options[:object].call(self)
          else
            options[:object]
          end
          !object.nil? && object.send(options[:method], options)
        end
        
        def unauthorized(options = {})
          options = self.class.authorization_options.merge(options)
          flash[options[:flash_type]] = options[:message] if options[:message]
          redirect_to respond_to?(options[:redirect_to]) ? send(options[:redirect_to]) : options[:redirect_to].to_s
          false
        end
    end
  end
end

ActionController::Base.extend Huberry::Authorization