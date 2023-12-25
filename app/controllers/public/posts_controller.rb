class Public::PostsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.new
    @post.user = current_user
  end

  def index
    if params[:latest]
      @posts = Post.latest.page(params[:page]).per(10)
    elsif params[:old]
      @posts = Post.old.page(params[:page]).per(10)
    elsif params[:favorite_count]
      @posts = Post.favorite_count.page(params[:page]).per(10)
    else
      @posts = Post.page(params[:page]).per(10)
    end
    @tag_lists = Tag.all
  end

  def show
    @post = Post.find(params[:id])
    @tag_lists = @post.tags
    @post_comment = PostComment.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_list = params[:post][:tag_name].split(/[[:blank:]]+/)  #splitメソッドで配列に変換
    if @post.save
      @post.create_tags(tag_list)  #create_tagsはpost.rbにメソッドを記載
      redirect_to user_path(current_user.id)
    else
      flash.now[:alert] = "投稿に失敗しました。必須項目を記入してください"
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
      flash[:notice] = "投稿を編集しました"
      redirect_to post_path(@post.id)
    else
      flash.now[:notice] = "必須項目を入力してください"
      render:edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to posts_path
  end

  def bookmarks
    bookmarks = Bookmark.where(user_id: current_user.id).pluck(:post_id) #post_id内からログイン中ユーザがブックマークしているidを探し取得
    @bookmarks = Post.find(bookmarks)
  end

  private

  def post_params
    params.require(:post).permit(:name, :campany, :caption, :image)
  end

end
