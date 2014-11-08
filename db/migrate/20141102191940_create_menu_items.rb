class CreateMenuItems < ActiveRecord::Migration
  def change
    create_table :menu_items do |t|
      t.string :sp_id
      t.string :name
      t.text :description
      t.integer :order_num
      t.boolean :dairy
      t.boolean :dairy_free
      t.boolean :egg
      t.boolean :egg_free
      t.boolean :fish
      t.boolean :fish_free
      t.boolean :gluten_free
      t.boolean :halal
      t.boolean :kosher
      t.boolean :organic
      t.boolean :peanut
      t.boolean :peanut_free
      t.boolean :shellfish
      t.boolean :shellfish_free
      t.boolean :soy
      t.boolean :soy_free
      t.string :spicy
      t.boolean :tree_nut
      t.boolean :tree_nut_free
      t.boolean :vegan
      t.boolean :vegetarian
      t.boolean :wheat
      t.references :restaurant, index: true
      t.references :menu_section, index: true

      t.timestamps
    end
  end
end
