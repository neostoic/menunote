class MenuChoice < ActiveRecord::Base
   def self.create_menu_choice(spChoice)
	choiceObj = MenuChoice.new({
		:name => spChoice['name'],
		:unit => spChoice['unit'],
		:order_num => spChoice['order_num']
	})
	spPrices = spChoice['prices']
	unless spPrices.nil?
		choiceObj['prices_max'] = spCalories['max']
		choiceObj['prices_min'] = spCalories['min']
	end
	spCalories = spChoice['calories']
	unless spCalories.nil?
		choiceObj['calories_max'] = spCalories['max']
		choiceObj['calories_min'] = spCalories['min']
	end
	return choiceObj
   end
end
