class SessionsController < ApplicationController
	def new		
	end

	def create
		user = User.find_by_email(params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
			# Sign user in and display user profile page
			sign_in user # jeszcze nieistniejaca funkcja sign_in
			redirect_to user # redirect to the profile page
		else
			# Show error message and display signin form again
			flash.now[:error] = 'Niewlasciwy email lub haslo.'
			render 'new'		
		end
	end

	def destroy		
		sign_out
		redirect_to root_url
	end
end
