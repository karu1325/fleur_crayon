class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @keyword = params[:keyword]
    split_keyword = params[:keyword].split(/[[:blank:]]+/)
     #キーワード検索（user,post)
    @posts = []
    if @range == "Post"
      split_keyword.each do |keyword|
        @posts << Post.search(keyword).order('created_at DESC')
      end
    else
      @users = User.search(@keyword).order('created_at DESC')
    end
    @posts = @posts.flatten.uniq
    #@posts = @posts.sort_by { |post| post.created_at }.reverse
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
