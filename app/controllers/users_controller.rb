class UsersController < ApplicationController

  layout 'user_self_administration', :only => [:update_password, :edit_password, :delete_account]
  before_filter :authenticate_user!

  # GET /users/update_password
  def update_password
    @user = User.find(current_user.id)
  end

  # GET /users/delete_account
  def delete_account
    @user = User.find(current_user.id)
  end

  # PUT /users/edit_password
  def edit_password
    @user = User.find(current_user.id)
    if @user.update_with_password(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path, notice: I18n.t('views.user.flash_messages.password_changed')
    else
      render action: 'update_password'
    end
  end

end
