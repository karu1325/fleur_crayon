class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @keywords = params[:keyword].split(/[[:blank:]]+/)
     #キーワード検索（user,post)
    if @range == "Post"
      @posts = Post.search(@keywords)
    else
      @users = User.search(@keywords)
    end
  end

  def tag_search
    if params[:tag_id].present? #タグのlinkから検索
      @tag = Tag.find(params[:tag_id]) #検索されたタグを受け取る
      @posts = @tag.posts
      @keyword = @tag.tag_name
    elsif params[:tag_search].present? #selectのタグ検索
      @tag = Tag.select("tag_name")
      @keyword = params[:tag_search]
      @posts = Tag.find_by(tag_name: @keyword).posts
    else
      @posts = []
    end
  end
end
