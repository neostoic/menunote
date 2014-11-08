class AddCountryToRestaurants < ActiveRecord::Migration
  def change
    add_column :restaurants, :country, :string
  end
end
