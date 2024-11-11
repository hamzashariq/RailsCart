class CreateProductSnapshots < ActiveRecord::Migration[7.2]
  def change
    create_table :product_snapshots do |t|
      t.references :order, null: false, foreign_key: true
      t.string :name
      t.decimal :price
      t.integer :quanitity

      t.timestamps
    end
  end
end
