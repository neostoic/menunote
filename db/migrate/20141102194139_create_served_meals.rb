class CreateServedMeals < ActiveRecord::Migration
  def change
    create_table :served_meals do |t|
      t.string :name
      t.references :restaurant, index: true

      t.timestamps
    end
  end
end
