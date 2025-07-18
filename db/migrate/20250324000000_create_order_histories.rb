class CreateOrderHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :order_histories do |t|
      t.references :order, null: false, foreign_key: true
      t.string :note, null: false
      t.string :status_from
      t.string :status_to

      t.timestamps
    end
  end
end
