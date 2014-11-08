class AddMenuToRestaurants < ActiveRecord::Migration
  def change
    add_reference :restaurants, :menu, index: true
  end
end
