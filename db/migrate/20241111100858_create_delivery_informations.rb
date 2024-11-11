class CreateDeliveryInformations < ActiveRecord::Migration[7.2]
  def change
    create_table :delivery_informations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.text :address
      t.references :order, null: false, foreign_key: true
      t.string :number
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
