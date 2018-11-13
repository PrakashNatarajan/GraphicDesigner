class ApplicationController < ActionController::Base
	before_action :authenticate_member!

  	protect_from_forgery with: :exception
	#skip_before_action :verify_authenticity_token  ##To Disable the CSRF Token
end
