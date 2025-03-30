class CreateReviews < ActiveRecord::Migration[7.2]
  def change
    create_table :reviews do |t|
      t.integer :rating, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end

    add_index :reviews, [:user_id, :product_id], unique: true
    add_check_constraint :reviews, "rating >= 1 AND rating <= 5", name: "rating_range_check"
  end
end
