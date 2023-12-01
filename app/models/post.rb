class Post < ApplicationRecord
  belongs_to :user
  has_many :post_tags, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_one_attached :image

  def get_image(width,height)
    unless image.attached?
      file_path = Rails.root.join('app/asset/images/498417.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg',content_type: 'image/jpg')
    end
    image.variant(resize_to_limit:[width,height]).processed
  end
end
