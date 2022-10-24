class CreateProcedures < ActiveRecord::Migration[6.1]
  def change
    create_table :procedures do |t|
      t.references :post, null: false, foreign_key: true
      t.text :explanation
      t.string :process_image

      t.timestamps
    end
  end
end
