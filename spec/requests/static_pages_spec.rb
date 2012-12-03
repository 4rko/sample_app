require 'spec_helper'

describe "StaticPages" do

	describe "Home Page" do
		it "should have content 'Sample App'" do
			visit root_path
			page.should have_content('Sample App')
		end
	end

	describe "Help Page" do
		it "should have content 'Help'" do
			visit help_path
			page.should have_content('Help')
		end
	end

	describe "About Page" do
		it "should have content 'About Us'" do
			visit about_path
			page.should have_content('About Us')
		end
	end

end
