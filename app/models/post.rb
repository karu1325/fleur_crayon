class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :tags, through: :post_tags

  has_one_attached :image

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/498417.jpg')
      image.attach(io: File.open(file_path), filename:'default-image.jpg', content_type:'image/jpg')
    end
    image.variant(resize_to_limit:[width,height]).processed
  end

  def create_tags(tag_list)
    tag_list.each do |tag| #splitで分けたtagをeach文で取得
      new_tag = Tag.find_or_create_by(tag_name: tag) #tagモデルに存在するならそのtagを使用、なければ新規登録
      tags << new_tag    #登録するpostのtagに紐づける
    end
  end
end
