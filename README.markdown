Huberry::Authorization
======================

A rails plugin that handles authorization


Installation
------------

	script/plugin install git://github.com/shuber/authorization.git


Note
----

This plugin assumes that your User belongs\_to a :role (association names are configurable) 
and (optionally) the :role has\_and\_belongs\_to_many :rights


Example
-------

	class User < ActiveRecord::Base
	  # Accepts an optional hash of options
	  #   :include_rights - (defaults to true)
	  #   :rights_association_name - (defaults to :rights)
	  #   :right_name_field - The field to use for the name of the right object (e.g. name or title) (defaults to :name)
	  #   :role_association_name - (defaults to :role)
	  #   :role_name_field - The field to use for the name of the role object (e.g. name or title) (defaults to :name)
	  uses_authorization :role_name_field => :title
	end
	
	class ApplicationController < ActionController::Base
	  # Set optional authorization options here
	  #   self.unauthorized_message = The error flash message to set when unauthorized (defaults to 'Unauthorized')
	  #   self.unauthorized_redirect_path = The path to redirect to when unauthorized (can be a symbol of a method) (defaults to '/')
	end
	
	class UsersController < ApplicationController
	  # Accepts a combination of :right(s) and :role - also excepts standard before filter options - :only and :except
	  # (also accepts an option :user which can be set to an object or a symbol representing the method that will return the current user - defaults to :current_user)
	  authorize :role => :admin, :except => [:index]
	  authorize :right => :show_user, :only => [:show]
	  authorize :rights => [:edit_user, :update_user], :only => [:edit, :update]
	  authorize :role => :super_admin, :right => :destroy_user, :only => [:destroy]
	
	  def destroy; end
	  def edit; end
	  def index; end
	  def show; end
	  def update; end
	end


Controller Methods
------------------

	# Calls unauthorized if the current user is not authorized? with the hash of rights/roles passed to it
	authorize(options = {})
	
	# Checks if the current user is authorized with the hash_of rights/roles passed to it (optionaly accepts a block that is yielded when true)
	authorized?(options = {})
	
	# This method is called with a user is not authorized (default behavior will set an error flash message and redirect)
	unauthorized


Model Methods
-------------

	# Checks if the user has all the rights passed to this method
	has_right?(right_or_rights_names) # aliased as has_rights?
	
	# Checks if the user's role is equal to the one passed to it
	is_role?(role_name)


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)