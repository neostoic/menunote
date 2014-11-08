class CreateHours < ActiveRecord::Migration
  def change
    create_table :hours do |t|
      t.string :name
      t.string :opening
      t.string :closing
      t.text :description
      t.references :restaurant, index: true

      t.timestamps
    end
  end
end
