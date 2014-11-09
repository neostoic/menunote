class Menu < ActiveRecord::Base
   belongs_to :restaurants

   def self.create_restaurant_menu(restaurant)	
	sp_id = restaurant.sp_id
	path = '/locations/' + sp_id + '/menus'
	spMenu = APIHandler.singleplatform_publishing(path, nil)
	if spMenu.nil?
		return nil
	end
	spMenu = spMenu['data']
	if spMenu.nil? || spMenu.length <= 0
		return nil
	end
	menuObj = Menu.new({
		:sp_id => spMenu['id'],
		:restaurant => restaurant,
		:name => spMenu['name'],
		:description => spMenu['description'],
		:menu_type => spMenu['menu_type'],
		:footnote => spMenu['footnote'],
		:order_num => spMenu['order_num'],
		:currency => spMenu['currency'],
		:attribution_image => spMenu['attribution_image'],
		:attribution_image_link => spMenu['attribution_image_link'] 
	})
	spMenuSections = spMenu['sections']
	unless spMenuSections.nil?
		menuObj.sections = Array.new
		spMenuSections.each do |section|
			menuSectionObj = MenuSection.create_menu_section(section, menuObj)
			menuObj.menu_sections << menuSectionObj
		end
	end
	return menuObj
   end
end
