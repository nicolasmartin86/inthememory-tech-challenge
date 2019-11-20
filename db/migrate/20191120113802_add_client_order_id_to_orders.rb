class AddClientOrderIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :client_order_id, :string
  end
end
