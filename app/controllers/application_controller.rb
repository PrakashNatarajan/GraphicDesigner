class ApplicationController < ActionController::Base
	before_action :authenticate_member!

  	protect_from_forgery with: :exception
end
