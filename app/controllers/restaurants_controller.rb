class RestaurantsController < ApplicationController
   def show
	@restaurant = Restaurant.find(params[:id])
	if @restaurant.menu.nil?
		@output = @restaurant.load_menu()
	end
	menu = @restaurant.get_restaurant_menu()
	unless menu.nil?
		if params[:menu_section].nil?
			@section = menu.menu_sections[1]
		else
			@section = menu.menu_sections.find_by_name(params[:menu_section])
		end
	end
   end
   def search
	@query = params[:query]
	@location = params[:location]
	@search_output = Restaurant.search_by_name(@query, @location)
   end
end
