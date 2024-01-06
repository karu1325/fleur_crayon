class Public::PostCommentsController < ApplicationController
  before_action :authenticate_user!

  def new
  end

  def create
    post = Post.find(params[:post_id])
    comment = current_user.post_comments.new(post_comment_params)
    comment.post = post
    if comment.save
      flash[:notice] = "コメントを送信しました"
      redirect_to post_path(post)
    else
      @post = post
      @tag_lists = @post.tags
      @post_comment = PostComment.new
      flash.now[:alert] = "コメントに失敗しました。1文字以上入力してください"
      render "public/posts/show"
    end
  end

  def destroy
    PostComment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def post_comment_params
    params.require(:post_comment).permit(:comment)
  end
end
