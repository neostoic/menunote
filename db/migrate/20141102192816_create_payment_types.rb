class CreatePaymentTypes < ActiveRecord::Migration
  def change
    create_table :payment_types do |t|
      t.string :name
      t.references :restaurant, index: true

      t.timestamps
    end
  end
end
