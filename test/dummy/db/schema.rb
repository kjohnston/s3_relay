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

ActiveRecord::Schema.define(version: 20141021002149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "products", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "s3_relay_uploads", force: true do |t|
    t.binary   "uuid"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.string   "upload_type"
    t.text     "filename"
    t.string   "content_type"
    t.string   "state"
    t.json     "data",         default: {}
    t.datetime "pending_at"
    t.datetime "imported_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
