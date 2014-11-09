class MenuAddition < ActiveRecord::Base
  belongs_to :menu_items
  def self.create_menu_addition(spAddition)
	additionObj = MenuAddition.new({
		:name => spAddition['name'],
		:unit => spAddition['unit'],
		:order_num => spAddition['order_num']
	})
	spPrices = spAddition['prices']
	unless spPrices.nil?
		additionObj.prices_max = spPrices['max']
		additionObj.prices_min = spPrices['min']
	end
	return additionObj
  end
end
