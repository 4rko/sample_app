def sign_in(user)
	visit signin_path
	fill_in "Email", with: user.email
	fill_in "Password", with: user.password
	click_button "Sign in"
	# Powyzsze nie dziala jak nie uzywam Capybary, dlatego ponizsze
	cookies[:remember_token] = user.remember_token
end