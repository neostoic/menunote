class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :sp_id
      t.string :name
      t.text :description
      t.string :menu_type
      t.string :footnote
      t.string :currency
      t.integer :order_num
      t.string :attribution_image
      t.string :attribution_image_link
      t.string :secure_attribute_image
      t.string :secure_attribution_image_link
      t.references :restaurant, index: true

      t.timestamps
    end
  end
end
