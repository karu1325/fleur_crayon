# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email:'admin@sample.com',
  password:'admin123'
)

cray = User.find_or_create_by!(email: "cray@sample.com") do |user|
  user.name = "Cray"
  user.password = "password1"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

post1 = Post.find_or_create_by!(name: "ボールペン") do |post|
  post.campany = "uni"
  post.caption ="可愛い桜色の本体に使いやすい三色が入った、細くて書き込みに便利なボールペンです！"
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post.user = cray
end

tag1 = Tag.create(tag_name: "ボールペン")
tag2 = Tag.create(tag_name: "かわいい")

post1.tags << tag1
post1.tags << tag2
