class AddMenuItemToImages < ActiveRecord::Migration
  def change
    add_reference :images, :menu_item, index: true
  end
end
