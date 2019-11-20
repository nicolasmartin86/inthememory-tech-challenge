class CreateSalesDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_details do |t|
      t.date :sale_date
      t.references :order, foreign_key: true
      t.references :customer, foreign_key: true
      t.string :country
      t.string :product_code
      t.string :product_description
      t.integer :quantity
      t.float :unit_price

      t.timestamps
    end
  end
end
