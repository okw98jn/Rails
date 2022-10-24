class AddTimeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :time, :string
  end
end
