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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120222195830) do

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.integer  "api_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "albums", ["api_id"], :name => "index_albums_on_api_id", :unique => true

  create_table "artists", :force => true do |t|
    t.string   "title"
    t.integer  "api_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "artists", ["api_id"], :name => "index_artists_on_api_id"

  create_table "likes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "likes", ["post_id"], :name => "index_likes_on_post_id"

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "song_id"
    t.integer  "like_count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "posts", ["song_id"], :name => "index_posts_on_song_id"
  add_index "posts", ["user_id", "created_at"], :name => "index_posts_on_user_id_and_created_at"

  create_table "songs", :force => true do |t|
    t.integer  "api_id"
    t.integer  "like_count"
    t.string   "title"
    t.integer  "album_id"
    t.integer  "artist_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "songs", ["album_id"], :name => "index_songs_on_album_id"
  add_index "songs", ["api_id"], :name => "index_songs_on_api_id", :unique => true
  add_index "songs", ["artist_id"], :name => "index_songs_on_artist_id"

  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "subscribed_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "subscriptions", ["subscribed_id"], :name => "index_subscriptions_on_subscribed_id"
  add_index "subscriptions", ["subscriber_id", "subscribed_id"], :name => "index_subscriptions_on_subscriber_id_and_subscribed_id", :unique => true
  add_index "subscriptions", ["subscriber_id"], :name => "index_subscriptions_on_subscriber_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "facebook_id"
    t.integer  "age"
    t.integer  "like_count"
    t.boolean  "active"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "users", ["first_name"], :name => "index_users_on_first_name"
  add_index "users", ["last_name"], :name => "index_users_on_last_name"
  add_index "users", ["username"], :name => "index_users_on_username"

end
