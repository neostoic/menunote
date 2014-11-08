class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :sp_id
      t.string :name
      t.text :description
      t.string :business_type
      t.boolean :out_of_business
      t.boolean :is_published
      t.datetime :published_at
      t.boolean :is_owner_verified
      t.string :phone
      t.string :email
      t.string :website
      t.string :time_zone
      t.datetime :created
      t.datetime :updated
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.string :cross_street
      t.string :neighborhood
      t.string :directions
      t.string :price_rating
      t.string :alcohol
      t.boolean :delivery
      t.boolean :take_out
      t.boolean :dine_in
      t.boolean :drive_thru
      t.boolean :catering
      t.boolean :wheelchair_access
      t.boolean :reservations
      t.string :average_price
      t.string :foursquare_id
      t.string :facebook_id
      t.string :yelp_id
      t.datetime :date_last_updated

      t.timestamps
    end
  end
end
