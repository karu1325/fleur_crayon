class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tags, through: :post_tags

  has_one_attached :image

  validates :name, presence: true,
                   length: { minimum: 1, maximum: 20 }
  validates :caption, presence: true,
                      length: { minimum: 1, maximum: 300 }
  validates :image, presence: true

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :favorite_count, -> {
    left_joins(:favorites)
    .select('posts.*, COUNT(favorites.id) AS favorite_count')
    .group('posts.id')
    .order('favorite_count DESC')
  }

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/498417.1.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpg')
    end
    image.variant(resize_to_limit:[width,height]).processed
  end

  def create_tags(sent_tags)
    current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
      #タグが存在していれば、タグの名前を配列として全て取得
    old_tags = current_tags - sent_tags
      #現在取得したタグから送られてきたタグを除いてoldtagとする
    new_tags = sent_tags - current_tags
      # 送られてきたタグから現在存在するタグをnewとする

    #　古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(tag_name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(tag_name: new) #tagモデルに存在するならそのtagを使用、なければ新規登録
      self.tags << new_post_tag    #登録するpostのtagに紐づける
    end
  end

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists? #userテーブルのidカラムの値がuser.idのレコードが存在するか,既にいいねしていないか確認
  end

  def bookmarked_by?(user)
    bookmarks.where(user_id: user.id).exists?
  end

  def self.search(search)
    if search.present?
      Post.where('name LIKE(?) OR campany LIKE(?) OR caption LIKE(?)', "%#{search}%", "%#{search}%", "%#{search}%")
    else
      Post.all.order('created_at DESC') #投稿一覧（昇順）
    end
  end
end
