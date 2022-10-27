# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

categories = ['お肉料理', '野菜料理', '魚介料理', 'パスタ', 'ご飯', '麺類', 'スープ', '鍋', 'サラダ', 'パン', 'お弁当', 'スイーツ', 'その他' ]
categories.each do |category|
  Category.create!(name: category)
end
