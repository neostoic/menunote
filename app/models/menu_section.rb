class MenuSection < ActiveRecord::Base
  belongs_to :parent
  belongs_to :menus
  belongs_to :restaurants
  has_many :menu_items
  def self.create_menu_section(spSection, menuObj)
	menuSectionObj = MenuSection.new({
		:sp_id => spSection['id'],
		:name => spSection['name'],
		:description => spSection['description'],
		:order_num => spSection['order_num'],
		:menu_id => menuObj.id,
		:restaurant_id => menuObj.restaurant_id
	})
	spSubSections = spSection['sub_sections']
	unless spSubSections.nil?
		spSubSections.each do |spSubSection|
			subSectionObj = MenuSection.create_menu_section(spSubSection, menuObj)
			subSectionObj.parent = spSection
		end
	end
	spItems = spSection['items']
	unless spItems.nil?
		menuItemObjArray = Array.new
		spItems.each do |spItem|
			menuItemObj = MenuItem.create_menu_item(spItem, menuSectionObj)
			menuItemObjArray << menuItemObj
		end
		menuSectionObj.menu_items = menuItemObjArray
	end
	return menuSectionObj
  end
end
