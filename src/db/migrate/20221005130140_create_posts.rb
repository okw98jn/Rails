class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :post_image
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
