class CreateMenuChoices < ActiveRecord::Migration
  def change
    create_table :menu_choices do |t|
      t.string :name
      t.string :unit
      t.integer :order_num
      t.decimal :prices_max
      t.decimal :prices_min
      t.integer :calories_max
      t.integer :calories_min
      t.references :menu_item, index: true

      t.timestamps
    end
  end
end
