class Public::PostsController < ApplicationController

  def new
    @post = Post.new
    @post.user = current_user
  end

  def index
  end

  def show
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    @post.save
    redirect_to users_path(current_user.id)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def search
  end

  private

  def post_params
    params.require(:post).permit(:name, :campany, :caption, :image)
  end
end
