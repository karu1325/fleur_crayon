class Public::UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.attributes = user_params
    if @user.save!(context: :update)
      flash[:notice] = "更新しました"
      redirect_to user_path(@user.id)
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def bookmarks
    bookmarks = Bookmark.where(user_id: current_user.id).pluck(:post_id) #post_id内からログイン中ユーザがブックマークしているidを探し取得
    @bookmarks = Post.find(bookmarks)
  end

  def confirm
  end

  def withdraw
    @user = User.find(current_user.id)
    @user.update(is_active: false)
    reset_session
    flash[:notice] = "退会しました。"
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image)
  end
end
