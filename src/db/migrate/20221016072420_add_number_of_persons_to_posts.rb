class AddNumberOfPersonsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :number_of_persons, :string
  end
end
