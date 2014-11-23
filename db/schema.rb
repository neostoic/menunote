# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141122223216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cuisine_types", force: true do |t|
    t.string   "name"
    t.integer  "restaurants_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cuisine_types", ["restaurants_id"], name: "index_cuisine_types_on_restaurants_id", using: :btree

  create_table "hours", force: true do |t|
    t.string   "name"
    t.string   "opening"
    t.string   "closing"
    t.text     "description"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hours", ["restaurant_id"], name: "index_hours_on_restaurant_id", using: :btree

  create_table "images", force: true do |t|
    t.text     "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "menu_item_id"
  end

  add_index "images", ["menu_item_id"], name: "index_images_on_menu_item_id", using: :btree

  create_table "menu_additions", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.integer  "order_num"
    t.decimal  "prices_max"
    t.decimal  "prices_min"
    t.integer  "menu_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_additions", ["menu_item_id"], name: "index_menu_additions_on_menu_item_id", using: :btree

  create_table "menu_choices", force: true do |t|
    t.string   "name"
    t.string   "unit"
    t.integer  "order_num"
    t.decimal  "prices_max"
    t.decimal  "prices_min"
    t.integer  "calories_max"
    t.integer  "calories_min"
    t.integer  "menu_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_choices", ["menu_item_id"], name: "index_menu_choices_on_menu_item_id", using: :btree

  create_table "menu_items", force: true do |t|
    t.string   "sp_id"
    t.string   "name"
    t.text     "description"
    t.integer  "order_num"
    t.boolean  "dairy"
    t.boolean  "dairy_free"
    t.boolean  "egg"
    t.boolean  "egg_free"
    t.boolean  "fish"
    t.boolean  "fish_free"
    t.boolean  "gluten_free"
    t.boolean  "halal"
    t.boolean  "kosher"
    t.boolean  "organic"
    t.boolean  "peanut"
    t.boolean  "peanut_free"
    t.boolean  "shellfish"
    t.boolean  "shellfish_free"
    t.boolean  "soy"
    t.boolean  "soy_free"
    t.string   "spicy"
    t.boolean  "tree_nut"
    t.boolean  "tree_nut_free"
    t.boolean  "vegan"
    t.boolean  "vegetarian"
    t.boolean  "wheat"
    t.integer  "restaurant_id"
    t.integer  "menu_section_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "images_id"
  end

  add_index "menu_items", ["images_id"], name: "index_menu_items_on_images_id", using: :btree
  add_index "menu_items", ["menu_section_id"], name: "index_menu_items_on_menu_section_id", using: :btree
  add_index "menu_items", ["restaurant_id"], name: "index_menu_items_on_restaurant_id", using: :btree

  create_table "menu_sections", force: true do |t|
    t.string   "sp_id"
    t.string   "name"
    t.text     "description"
    t.integer  "order_num"
    t.integer  "parent_id"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "menu_id"
  end

  add_index "menu_sections", ["menu_id"], name: "index_menu_sections_on_menu_id", using: :btree
  add_index "menu_sections", ["parent_id"], name: "index_menu_sections_on_parent_id", using: :btree
  add_index "menu_sections", ["restaurant_id"], name: "index_menu_sections_on_restaurant_id", using: :btree

  create_table "menus", force: true do |t|
    t.string   "sp_id"
    t.string   "name"
    t.text     "description"
    t.string   "menu_type"
    t.string   "footnote"
    t.string   "currency"
    t.integer  "order_num"
    t.string   "attribution_image"
    t.string   "attribution_image_link"
    t.string   "secure_attribute_image"
    t.string   "secure_attribution_image_link"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menus", ["restaurant_id"], name: "index_menus_on_restaurant_id", using: :btree

  create_table "payment_types", force: true do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_types", ["restaurant_id"], name: "index_payment_types_on_restaurant_id", using: :btree

  create_table "restaurants", force: true do |t|
    t.string   "sp_id"
    t.string   "name"
    t.text     "description"
    t.string   "business_type"
    t.boolean  "out_of_business"
    t.boolean  "is_published"
    t.datetime "published_at"
    t.boolean  "is_owner_verified"
    t.string   "phone"
    t.string   "email"
    t.string   "website"
    t.string   "time_zone"
    t.datetime "created"
    t.datetime "updated"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "cross_street"
    t.string   "neighborhood"
    t.string   "directions"
    t.string   "price_rating"
    t.string   "alcohol"
    t.boolean  "delivery"
    t.boolean  "take_out"
    t.boolean  "dine_in"
    t.boolean  "drive_thru"
    t.boolean  "catering"
    t.boolean  "wheelchair_access"
    t.boolean  "reservations"
    t.string   "average_price"
    t.string   "foursquare_id"
    t.string   "facebook_id"
    t.string   "yelp_id"
    t.datetime "date_last_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "menu_id"
    t.string   "country"
  end

  add_index "restaurants", ["menu_id"], name: "index_restaurants_on_menu_id", using: :btree

  create_table "served_meals", force: true do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "served_meals", ["restaurant_id"], name: "index_served_meals_on_restaurant_id", using: :btree

end
