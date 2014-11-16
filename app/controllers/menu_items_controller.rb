class MenuItemsController < ApplicationController
   def show
	@menu_item = MenuItem.find(params[:id])
	@reviews = @menu_item.get_reviews().sort_by{|r| r['date_created']}.reverse!
   end
end
