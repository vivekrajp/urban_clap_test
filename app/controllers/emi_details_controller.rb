class EmiDetailsController < ApplicationController
	def show
		require 'csv'    

		emi_rate = File.read('tmp/emi_rates.csv')
		emi_rate_csv = CSV.parse(emi_rate, :headers => true)

		emi_details = []
		emi_rate_csv.each do |row|
		  puts row.inspect
		  if row["Minimum"].to_i <= params["amount"].to_i
		  	updated_already_exists = false
		  	emi_details.each do |emi_detail|
		  		if emi_detail[:bank] == row["Lender"]
		  			emi_detail[:tenures] << [{"months": row["Tenure"], "rate": row["Rate"], "mininum_amount": row["Minimum"]}]
		  			updated_already_exists = true
		  		end	
		  	end
		  	emi_details << {"bank": row["Lender"], "tenures": [{"months": row["Tenure"], "rate": row["Rate"], "mininum_amount": row["Minimum"]}]} unless updated_already_exists
		  end	
		end

		puts emi_details.inspect

	    render json: emi_details
	end	
end
