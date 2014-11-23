class AddPhotosToMenuItem < ActiveRecord::Migration
  def change
    add_reference :menu_items, :images, index: true
  end
end
