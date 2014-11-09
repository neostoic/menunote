class MenuItem < ActiveRecord::Base
   belongs_to :menu_sections
   has_many :menu_additions
   has_many :menu_choices
   def self.create_menu_item(spItem, sectionObj)
	menuItemObj = MenuItem.new(
		:sp_id => spItem['id'],
		:name => spItem['name'],
		:description => spItem['description'],
		:order_num => spItem['order_num'],
		:menu_section => sectionObj,
		:restaurant => sectionObj.restaurant
	)
	itemAttr = spItem['attributes']
	unless itemAttributes.nil?
		menuItemObj.dairy = itemAttr['dairy']
		menuItemObj.dairy_free = itemAttr['dairy-free']
		menuItemObj.egg = itemAttr['egg']
		menuItemObj.egg_free = itemAttr['egg-free']
		menuItemObj.fish = itemAttr['fish']
		menuItemObj.fish_free = itemAttr['fish-free']
		menuItemObj.gluten_free = itemAttr['gluten_free']
		menuItemObj.halal = itemAttr['halal']
		menuItemObj.kosher = itemAttr['kosher']
		menuItemObj.organic = itemAttr['organic']
		menuItemObj.peanut = itemAttr['peanut']
		menuItemObj.peanut_free = itemAttr['peanut_free']
		menuItemObj.shellfish = itemAttr['shellfish']
		menuItemObj.shellfish_free = itemAttr['shellfish_free']
		menuItemObj.soy = itemAttr['soy']
		menuItemObj.soy_free = itemAttr['soy-free']
		menuItemObj.spicy = itemAttr['spicy']
		menuItemObj.tree_nut = itemAttr['tree-nut']
		menuItemObj.tree_nut_free = itemAttr['tree-nut-free']
		menuItemObj.vegan = itemAttr['vegan']
		menuItemObj.vegtarian = itemAttr['vegetarian']
		menuItemObj.wheat = itemAttr['wheat']
	end
	spAdditions = spItem['additions']
	unless spAdditions.nil? || spAdditions.length === 0
		menuAdditionArr = Array.new
		spAdditions.each do |spAddition|
			menuAdditionObj = MenuAddition.create_menu_addition(spAddition)
			menuAdditionObj.menu_item = menuItemObj
			menuAdditionArr << menuAdditionObj
		end
		menuItemObj.menu_additions = menuAdditionArr
	end
	spChoices = spItem['choices']
	unless spChoices.nil? || spChoices.length === 0
		menuChoicesArr = Array.new
		spChoices.each do |spChoice|
			menuChoiceObj = MenuChoice.create_menu_choice(spChoice)
			menuChoiceObj.menu_item = menuItemObj
			menuChoiceArr << menuChoiceObj
		end
		menuChoiceObj.menu_choices = menuChoicesArr
	end
	return menuItemObj
   end
end
