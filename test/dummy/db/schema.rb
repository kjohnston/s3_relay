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

ActiveRecord::Schema.define(version: 20141009000804) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "s3_relay_uploads", force: true do |t|
    t.string   "parent_type"
    t.integer  "parent_id"
    t.binary   "uuid"
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
