require 'spec_helper'

describe "AuthenticationPages (Uwierzytelnianie)" do
	subject { page }

	describe "SignIn page" do
		before { visit signin_path }
		
		it { should have_selector('h1',    text: 'Sign in') }
		it { should have_selector('title', text: 'Sign in') }	

		describe "Form with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') } 
      it { should have_selector('div.alert.alert-error', text: 'Niewlasciwy') }

      describe "After visiting another page" do
        before { click_link "Home" }

        it { should_not have_selector('div.alert.alert-error', text: 'Niewlasciwy') }
      end
    end 

    describe "Form with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user } # funkcja sign_in(user) z spec/support/utilities.rb

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by sign out" do
        before { click_link 'Sign out' } # cudzyslow vs apostrofy
        it { should have_link('Sign in', href: signin_path) }
        it { should_not have_link('Sign out', href: signout_path) }
      end
    end
	end

  describe "Autoryzacja" do
    describe "dla niezalogowanych uzytkownikow" do
      let(:user) { FactoryGirl.create(:user) }

      describe "proba odwiedzenia chronionej strony" do
        before do # sign_in user
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "po zalogowaniu" do
          it "should render the desired protected page" do
           should have_selector('title', text: "Edycja uzytkownika")
          end
        end
      end

      describe "w kontrolerze Uzytkownikow" do
        describe "odwiedzanie strony edycji" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to signin_path }
        end

        describe "odwiedzenie spisu uzytkownikow" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end
      end
    end    

    describe "jako zalogowany ale niewlasciwy uzytkownik" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "odwiedzanie strony Users#edit" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector(:title, text: 'Edycja uzytkownika') }
      end

      describe "submitting a PUT request to Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to root_path }
      end
    end

    describe "jako zwykly uzytkownik" do
      let(:user)      { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "wysylanie zadania DELETE do akcji Users#destroy" do
        before { delete user_path(user) }
        specify { response.should redirect_to root_path } # zwykly uzytkownik nie powinien moc usuwac
      end
    end
  end
end

# z generatora:
# describe "AuthenticationPages" do
#   describe "GET /authentication_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get authentication_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end
