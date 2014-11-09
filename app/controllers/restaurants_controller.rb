class RestaurantsController < ApplicationController
   def show
	@restaurant = Restaurant.find(params[:id])
	if @restaurant.menu.nil?
		@output = @restaurant.load_menu()
	end
   end
   def search
	@query = params[:query]
	@location = params[:location]
	@search_output = Restaurant.search_by_name(@query, @location)
   end
end
