class UsersController < ApplicationController
  respond_to :json, :html

  def edit
    @user = current_user
    respond_with @user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:success] = "Successfully updated user information"
      redirect_to :back
    else
      flash[:error] = "Problem updating user"
      redirect_to :back
    end
  end

end
