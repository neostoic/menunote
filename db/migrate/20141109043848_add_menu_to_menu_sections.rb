class AddMenuToMenuSections < ActiveRecord::Migration
  def change
    add_reference :menu_sections, :menu, index: true
  end
end
