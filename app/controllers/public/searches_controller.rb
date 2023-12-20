class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @keyword = params[:keyword]
    split_keyword = params[:keyword].split(/[[:blank:]]+/)
     #キーワード検索（user,post)
    if @range == "Post"
      split_keyword.each do |keyword|
          @posts = Post.search(keyword).order('created_at DESC')
      end
    else
      @users = User.search(@keyword).order('created_at DESC')
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
