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

ActiveRecord::Schema.define(version: 20161118013551) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "story_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_bookmarks_on_story_id", using: :btree
    t.index ["user_id"], name: "index_bookmarks_on_user_id", using: :btree
  end

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "story_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["story_id"], name: "index_comments_on_story_id", using: :btree
    t.index ["user_id"], name: "index_comments_on_user_id", using: :btree
  end

  create_table "followings", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "follower_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["follower_id"], name: "index_followings_on_follower_id", using: :btree
    t.index ["user_id"], name: "index_followings_on_user_id", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "identities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_models_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_models_on_reset_password_token", unique: true, using: :btree
  end

  create_table "notification_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "notified_by_user_id"
    t.integer  "notification_category_id"
    t.boolean  "read"
    t.integer  "origin_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "options"
    t.index ["notification_category_id"], name: "index_notifications_on_notification_category_id", using: :btree
    t.index ["notified_by_user_id"], name: "index_notifications_on_notified_by_user_id", using: :btree
    t.index ["user_id"], name: "index_notifications_on_user_id", using: :btree
  end

  create_table "pictures", force: :cascade do |t|
    t.integer  "story_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.index ["story_id"], name: "index_pictures_on_story_id", using: :btree
  end

  create_table "reaction_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reactions", force: :cascade do |t|
    t.integer  "story_id"
    t.integer  "reaction_category_id"
    t.integer  "user_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["reaction_category_id"], name: "index_reactions_on_reaction_category_id", using: :btree
    t.index ["story_id"], name: "index_reactions_on_story_id", using: :btree
    t.index ["user_id"], name: "index_reactions_on_user_id", using: :btree
  end

  create_table "stories", force: :cascade do |t|
    t.string   "raw_title"
    t.text     "raw_body"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "final_title"
    t.text     "final_body"
    t.boolean  "published",               default: false
    t.integer  "admin_id"
    t.integer  "author_id"
    t.integer  "poster_id"
    t.string   "updated_title"
    t.text     "updated_body"
    t.integer  "user_id"
    t.boolean  "anonymous"
    t.datetime "admin_published_at"
    t.string   "main_image_file_name"
    t.string   "main_image_content_type"
    t.integer  "main_image_file_size"
    t.datetime "main_image_updated_at"
    t.boolean  "review",                  default: false
    t.string   "last_user_to_update"
    t.string   "slug"
    t.datetime "deleted_at"
    t.index ["admin_id"], name: "index_stories_on_admin_id", using: :btree
    t.index ["author_id"], name: "index_stories_on_author_id", using: :btree
    t.index ["poster_id"], name: "index_stories_on_poster_id", using: :btree
    t.index ["slug"], name: "index_stories_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_stories_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "admin",                  default: false
    t.string   "first_name"
    t.string   "last_name"
    t.text     "about_me"
    t.string   "provider"
    t.string   "uid"
    t.string   "status"
    t.string   "gender"
    t.string   "age_range"
    t.string   "image"
    t.date     "birthday"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "fbimage"
    t.string   "slug"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["slug"], name: "index_users_on_slug", unique: true, using: :btree
  end

  add_foreign_key "bookmarks", "stories"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "stories"
  add_foreign_key "comments", "users"
  add_foreign_key "followings", "users"
  add_foreign_key "notifications", "notification_categories"
  add_foreign_key "notifications", "users"
  add_foreign_key "pictures", "stories"
  add_foreign_key "reactions", "reaction_categories"
  add_foreign_key "reactions", "stories"
  add_foreign_key "reactions", "users"
  add_foreign_key "stories", "users"
  add_foreign_key "stories", "users", column: "admin_id"
  add_foreign_key "stories", "users", column: "author_id"
  add_foreign_key "stories", "users", column: "poster_id"
end
