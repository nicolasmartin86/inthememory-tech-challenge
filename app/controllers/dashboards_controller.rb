class DashboardsController < ApplicationController
    def index
        @countries = select_countries
        @customer_count = customer_count
        @revenues = revenues
        @average_revenue_per_order = average_revenue_per_order
        @revenue_per_month = revenue_per_month
    end

    def select_countries
        array = []
        select_clause_countries = SalesDetail.select(:country).group(:country)
        array = select_clause_countries.map { |sales_detail| sales_detail.country }
        return array
    end

    def customer_count
        SalesDetail.from(SalesDetail.select(:customer_id, :country).distinct).group(:country).count
    end

    def revenues
        request = "
            sales_details.country,
            SUM(sales_details.quantity * sales_details.unit_price) as total_revenue
        "
        SalesDetail.select(request).group(:country).as_json(:except => :id)
    end

    def average_revenue_per_order
        total_revenue = revenues
        orders = order_count
        array = []
        revenues.each do |r|
            average = {}
            num_order = orders[r['country']]
            average[:country] = r['country']
            average[:average_rpo] = r['total_revenue'].fdiv(num_order)
            array << average
        end
        return array
    end

    def order_count
        SalesDetail.from(SalesDetail.select(:order_id, :country).distinct).group(:country).count
    end

    
    def revenue_per_month
        request = "
        sales_details.country, 
        CONCAT(date_part('year', sales_details.sale_date), '-', date_part('month', sales_details.sale_date)) as date_year_month, 
        SUM(sales_details.quantity * sales_details.unit_price) as monthly_revenue"
        SalesDetail.select(request).group(:country, :'date_year_month').as_json(:except => :id)
    end
end
