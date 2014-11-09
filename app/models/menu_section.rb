class MenuSection < ActiveRecord::Base
  belongs_to :parent
  belongs_to :restaurants
  has_many :menu_items
  def self.create_menu_section(spSection, menuObj)
	menuSectionObj = MenuSection.new({
		:sp_id => section['id'],
		:name => section['name'],
		:description => section['description'],
		:order_num => section['order_num'],
		:menu => menuObj,
		:restaurant => menuObj.restaurant
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
			menuItemObj.menu_section = menuSectionObj
			menuItemObjArray << menuItemObj
		end
		menuItemObj.menu_items = menuItemObjArray
	end
	return menuSectionObj
  end
end
