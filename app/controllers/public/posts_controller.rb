class Public::PostsController < ApplicationController
  before_action :authenticate_user!

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
    if @post.save
      @post.create_tags(tag_list)  #create_tagsはpost.rbにメソッドを記載
      redirect_to user_path(current_user.id)
    else
      render:new
    end
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:tag_name).join(' ') #配列を文字列に変換
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:tag_name].split
    if @post.update(post_params)
      @post.create_tags(tag_list)
      redirect_to post_path(@post.id)
    else
      render:edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path
  end

  def search
  end

  def bookmarks
    bookmarks = Bookmark.where(user_id: current_user.id).pluck(:post_id) #post_id内からログイン中ユーザがブックマークしているidを探し取得
    @bookmarks = Post.find(bookmarks)
  end

  private

  def post_params
    params.require(:post).permit(:name, :campany, :caption, :image)
  end

  def tag_params
    params.require(:post).permit(:tag_name)
  end
end
