class CreateMenuSections < ActiveRecord::Migration
  def change
    create_table :menu_sections do |t|
      t.string :sp_id
      t.string :name
      t.text :description
      t.integer :order_num
      t.belongs_to :parent, index: true
      t.references :restaurant, index: true
      t.timestamps
    end
  end
end
