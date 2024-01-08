class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @keyword = params[:keyword]
    keyword = params[:keyword].split(/[[:blank:]]+/).join
    reverse_keyword = params[:keyword].split(/[[:blank:]]+/).sort.join
     #キーワード検索（user,post)
    @posts = []
    @users =[]
    if @range == "Post"
      #split_keyword.each do |keyword|
        @posts << Post.search(keyword).order('created_at DESC').page(params[:page]).per(10)
        @posts << Post.search(reverse_keyword).order('created_at DESC').page(params[:page]).per(10)
      #end
    else
      #split_keyword.each do |keyword|
        @users << User.search(keyword).order('created_at DESC').page(params[:page]).per(10)
        @users << User.search(reverse_keyword).order('created_at DESC').page(params[:page]).per(10)
      #end
    end
    @posts = @posts.flatten.uniq
    #@posts = @posts.sort_by { |post| post.created_at }.reverse
    @users = @users.flatten.uniq
  end

  def tag_search
    if params[:tag_id].present? #タグのlinkから検索
      @tag = Tag.find(params[:tag_id]) #検索されたタグを受け取る
      @posts = @tag.posts.page(params[:page]).per(10)
      @keyword = @tag.tag_name
    elsif params[:tag_search].present? && params[:tag_search] != "" #selectのタグ検索
      @tag = Tag.select("tag_name")
      @keyword = params[:tag_search]
      @posts = Tag.find_by(tag_name: @keyword).posts.page(params[:page]).per(10)
    else
      @posts = []
    end
  end
end
