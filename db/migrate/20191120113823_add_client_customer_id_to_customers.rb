class AddClientCustomerIdToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :client_customer_id, :string
  end
end
