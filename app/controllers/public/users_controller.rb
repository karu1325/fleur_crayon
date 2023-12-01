class Public::UsersController < ApplicationController

  def show
  end

  def edit
  end

  def update
  end

  def confirm
  end

  def withdraw
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
end
