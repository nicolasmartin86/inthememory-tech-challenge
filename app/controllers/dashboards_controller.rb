class DashboardsController < ApplicationController
    def index
        @countries = select_countries
        country = params[:country] ? params[:country] : "All" 
        @customer_count = customer_count(country)
        @revenues = revenues(country)
        @average_revenue_per_order = average_revenue_per_order(country)
        @revenue_per_month = revenue_per_month(country)
    end

    def select_countries
        array = []
        select_clause_countries = SalesDetail.select(:country).group(:country)
        array = select_clause_countries.map { |sales_detail| sales_detail.country }
        array.sort
        array.unshift("All")
        return array
    end

    def customer_count(country)
        customers = SalesDetail.from(SalesDetail.select(:customer_id, :country).distinct).group(:country).count
        all_customers = SalesDetail.from(SalesDetail.select(:customer_id).distinct).count
        if country == "All"
            return all_customers
        else 
            return customers[country]
        end
    end

    def revenues(country)
        request = "
            sales_details.country,
            SUM(sales_details.quantity * sales_details.unit_price) as total_revenue
        "
        selected_country = SalesDetail.select(request).group(:country).as_json(:except => :id).detect do |c|
            c["country"] == country
        end
        if country == "All"
            return SalesDetail.sum("quantity * unit_price")
        else 
            return selected_country["total_revenue"]
        end
    end

    def average_revenue_per_order(country)
        total_revenue = revenues(country)
        orders = order_count(country)
        return total_revenue.fdiv(orders)
    end

    def order_count(country)
        orders = SalesDetail.from(SalesDetail.select(:order_id, :country).distinct).group(:country).count
        all_orders = SalesDetail.from(SalesDetail.select(:order_id).distinct).count
        if country == "All"
            return all_orders
        else 
            return orders[country]
        end
    end

    
    def revenue_per_month(country)
        request = "
        sales_details.country, 
        CONCAT(date_part('year', sales_details.sale_date), '-', date_part('month', sales_details.sale_date)) as date_year_month, 
        SUM(sales_details.quantity * sales_details.unit_price) as monthly_revenue"
        global_request = "
        CONCAT(date_part('year', sales_details.sale_date), '-', date_part('month', sales_details.sale_date)) as date_year_month, 
        SUM(sales_details.quantity * sales_details.unit_price) as monthly_revenue
        "
        if country == "All"
            return SalesDetail.select(global_request).group(:'date_year_month').to_json(:except => :id)
        else 
            return SalesDetail.select(request).where(country: country).group(:country, :'date_year_month').to_json(:except => :id)
        end
    end
end

