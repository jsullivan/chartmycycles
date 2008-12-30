# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081217224506) do

  create_table "avatars", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charting_fors", :force => true do |t|
    t.string   "chart_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "post_id"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cycles", :force => true do |t|
    t.datetime "started"
    t.datetime "ended"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "current",           :default => true
    t.boolean  "shared",            :default => false
    t.string   "custom1"
    t.string   "custom2"
    t.string   "custom3"
    t.string   "custom4"
    t.datetime "phase_one_end"
    t.datetime "phase_three_start"
  end

  create_table "entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "cycle_id"
    t.boolean  "peak"
    t.boolean  "intercourse"
    t.boolean  "period"
    t.boolean  "moody"
    t.boolean  "insomnia"
    t.boolean  "acne"
    t.boolean  "bloating"
    t.boolean  "cramps"
    t.float    "temp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "chart_date"
    t.text     "comment"
    t.string   "cervix_position"
    t.string   "cervix_firmness"
    t.string   "mucus"
    t.string   "vaginal_sensation"
    t.string   "cervix_opening"
  end

  create_table "forums", :force => true do |t|
    t.string   "topic"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  create_table "orders", :force => true do |t|
    t.string   "confirmation_number"
    t.string   "payment_transaction_id"
    t.string   "billing_address"
    t.string   "billing_city"
    t.string   "billing_state"
    t.string   "billing_zip"
    t.datetime "confirmed_at"
    t.datetime "processed_at"
    t.datetime "cancelled_at"
    t.integer  "user_id"
    t.integer  "status"
    t.integer  "total_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "forum_id"
    t.text     "body"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "city"
    t.string   "state"
    t.integer  "charting_for_id"
    t.datetime "birthdate"
    t.datetime "last_login"
    t.integer  "children"
    t.string   "motto"
    t.boolean  "member",                                  :default => false
    t.datetime "member_start_date"
  end

end
