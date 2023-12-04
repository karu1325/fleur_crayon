class Public::PostsController < ApplicationController

  def new
    @post = Post.new
    @post.user = current_user
  end

  def index
    @posts = Post.all
    @tag_lists = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @tag_lists = @post.tags
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split  #splitメソッドで配列に変換
    @post.create_tags(tag_list)  #create_tagsはpost.rbにメソッドを記載
    @post.save
    redirect_to user_path(current_user.id)
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update(post_params)
    redirect_to post_path(@post.id)
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def search
  end

  private

  def post_params
    params.require(:post).permit(:name, :campany, :caption, :image)
  end

  def tag_params
    params.require(:post).permit(:tag_name)
  end
end
