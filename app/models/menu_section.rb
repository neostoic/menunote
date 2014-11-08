class MenuSection < ActiveRecord::Base
  belongs_to :parent
  belongs_to :restaurants
  has_many :menu_items
end
