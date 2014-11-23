class AddPhotoUrlToMenuItems < ActiveRecord::Migration
  def change
    add_column :menu_items, :photo_url, :text
  end
end
