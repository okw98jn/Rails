class CreateMaterials < ActiveRecord::Migration[6.1]
  def change
    create_table :materials do |t|
      t.references :post, null: false, foreign_key: true
      t.string :material_name
      t.string :quantity

      t.timestamps
    end
  end
end
