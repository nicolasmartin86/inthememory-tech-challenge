require 'date'
require 'csv'

start_seed = Time.now

puts "Destroying all sales details"

SalesDetail.delete_all

puts "Destroying all orders"

Order.delete_all

puts "Destroying all customers"

Customer.delete_all


csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath = 'lib/assets/memory-tech-challenge-data.csv'



puts "Creating customers!"

customers_array = []

CSV.foreach(filepath, csv_options) do |row|
    customer_hash = { client_customer_id: row['customer_id'] }
    customers_array << customer_hash
end

customers_array = customers_array.uniq

puts "Importing customers!"

Customer.import(customers_array)

puts "Creating orders!"

orders_array = []

CSV.foreach(filepath, csv_options) do |row|
    order_hash = { client_order_id: row['order_id'] }
    orders_array << order_hash
end

orders_array = orders_array.uniq

puts "Importing orders!"

Order.import(orders_array)

puts "Creating sales details!"

sales_details_array = []

customer_list_hash = Customer.pluck(:client_customer_id, :id).to_h
order_list_hash = Order.pluck(:client_order_id, :id).to_h

CSV.foreach(filepath, csv_options) do |row|
    sales_params = {
        sale_date: row['date'].to_date,
        customer_id: customer_list_hash[row['customer_id']],
        order_id: order_list_hash[row['order_id']],
        country: row['country'],
        product_code: row['product_code'],
        product_description: row['product_description'],
        quantity: row['quantity'].to_i,
        unit_price: row['unit_price'].to_f
    }
    sales_details_array << sales_params
end

puts "Importing sales details!"

SalesDetail.import(sales_details_array)

finish_seed = Time.now

seconds_total = finish_seed - start_seed

def time_elapsed(seconds_elapsed)
    puts "----------------------------------------------------"
    puts "Seed Runtime: #{(seconds_elapsed/60.0).floor(0)}min #{(seconds_elapsed - ((seconds_elapsed/60.0).floor(0) * 60)).floor(0)}s"
    puts "----------------------------------------------------"
end

time_elapsed(seconds_total)

