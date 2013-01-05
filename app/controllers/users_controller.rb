class UsersController < ApplicationController
  before_filter :signed_in_user,     only: [:index, :edit, :update, :destroy] # przed kazdym wykonaniem akcji wymienionych po only: wykonaj metode z pierwszego argumentu, czyli signed_in_user
  before_filter :correct_user?,      only: [:edit, :update]
  before_filter :admin_user,         only: :destroy
  before_filter :not_signed_in_user, only: [:new, :create]

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		# obsługa udanego zapisu
      sign_in @user
  		flash[:success] = "Stworzylas/-es sobie konto. Gratulacje!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      # Handle successful update
      flash[:success] = 'Zmieniles swoj profil :-]'
      sign_in @user 
      # Note that we sign in the user as part of a successful profile update; 
      # this is because the remember token gets reset when the user is saved (Listing 8.18), 
      # which invalidates the user’s session (Listing 8.22). 
      # This is a nice security feature, as it means that any hijacked sessions will automatically expire when the user information is changed.
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    user = User.find(params[:id])
    unless user.admin?
      user.destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  private
    def signed_in_user
      unless signed_in? 
        store_location
        redirect_to signin_url, notice: 'Prosze sie zalogowac.' 
      end
    end

    def correct_user?
      @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
    end

    def admin_user
      redirect_to root_path unless current_user.admin?
    end

    def not_signed_in_user
      if signed_in? 
        redirect_to root_path 
      end
    end
end
