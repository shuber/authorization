authorization
=============

A rails plugin that handles authorization


Installation
------------

	script/plugin install git://github.com/shuber/authorization.git


Usage
-----

### Model ###

You must define an instance method such as `:authorized?` (customizable - see "Options") on your User class or whatever class you're 
authorizing. It will be passed a hash of options from the controller and must return true or false.

	class User < ActiveRecord::Base
	  def authorized?(options)
	    # does some logic to determine if this user is authorized or not
	    # returns a boolean
	  end
	end


### Controller ###

In the example below, the `:current_user` (customizable - see "Options") is only checked for authorization on the `:destroy`, `:edit`, 
and `:update` actions. In a before\_filter, the `:current_user`'s `:authorized?` method is called with whatever options that you 
passed to `authorize`. If the `:authorized?` method returns true, the request goes through like normal, otherwise, the request 
is redirected to the `unauthorized_redirect_path` (see below) with `unauthorized_message` (see below) as the flash error.

	class UsersController < ApplicationController
	  authorize :role => admin, :only => [:destroy, :edit, :update]
	  
	  def destroy; end
	  def edit; end
	  def index; end
	  def show; end
	  def update; end
	end

Controllers also have an instance method called `authorized?` which accepts the same options as the `authorize` method. You can use this 
if you want to check if an object is authorized without redirecting if it isn't. For example:

	class UsersController < ApplicationController
	  def some_action
	    if authorized? :role => :admin
	      # do something
	    else
	      # do something else
	    end
	  end
	end

`authorized?` is a helper method so you can use it in your views as well.

When authorization fails, the controller's instance method `unauthorized` is called. It simply sets a flash error and redirects. You can 
overwrite this method if you'd like to do something different.


### Options ###

Your controllers have a class method called `authorization_options` which contains a hash with the default authorization options:

	# The type of flash message to use when authorization fails. Defaults to :error.
	:flash_type
	
	# The flash message to use when authorization fails. If set to false, no flash is set. Defaults to 'Unauthorized'.
	:message
	
	# The method to call to check if an object is authorized. Defaults to :authorized?
	:method
	
	# The object to authorize. If set to a proc or a symbol representing an instance method, it is evaluated and the resulting 
	# object is checked for authorization. Defaults to :current_user.
	:object
	
	# The path to redirect to if authorization fails. Accepts a string or a symbol representing an instance method to call. 
	# Defaults to '/'
	:redirect_to

These options can be overwritten when you use the `authorize` method. In the example below, if authorization fails when viewing 
the `:destroy` action, the message `Only admins can destroy users` is used. If authorization fails on any other action, the 
default `:message` is used (`Unauthorized` in this case).

	class UsersController < ApplicationController
	  authorize :role => admin, :message => 'Only admins can destroy users', :only => [:destroy]
	  authorize :role => admin, :except => [:destroy]
	end


Contact
-------

Problems, comments, and suggestions all welcome: [shuber@huberry.com](mailto:shuber@huberry.com)