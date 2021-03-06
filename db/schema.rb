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

ActiveRecord::Schema.define(version: 20181202213721) do

  create_table "album_idents", id: false, force: :cascade do |t|
    t.integer "album_id",   limit: 4,   null: false
    t.string  "type",       limit: 32
    t.string  "identifier", limit: 255, null: false
  end

  add_index "album_idents", ["identifier"], name: "in_ident", using: :btree

  create_table "albums", force: :cascade do |t|
    t.integer  "external_id",   limit: 4
    t.string   "name",          limit: 255
    t.integer  "artist",        limit: 4
    t.integer  "created_by",    limit: 4,   null: false
    t.datetime "creation_date"
  end

  create_table "artists", force: :cascade do |t|
    t.integer  "external_id",   limit: 4
    t.string   "name",          limit: 255
    t.integer  "created_by",    limit: 4,   null: false
    t.datetime "creation_date"
  end

  add_index "artists", ["name"], name: "index_artists_on_name", type: :fulltext

  create_table "config", force: :cascade do |t|
    t.string "key",   limit: 255,   null: false
    t.text   "value", limit: 65535
  end

  add_index "config", ["key"], name: "index_config_on_key", unique: true, using: :btree

  create_table "exports", primary_key: "export_id", force: :cascade do |t|
    t.integer  "track_id",    limit: 4,  null: false
    t.datetime "export_date",            null: false
    t.string   "export_type", limit: 32
    t.integer  "playout_id",  limit: 4
  end

  add_index "exports", ["playout_id"], name: "in_export", using: :btree
  add_index "exports", ["track_id"], name: "in_track", using: :btree

  create_table "migrate_cache", primary_key: "cart_id", force: :cascade do |t|
    t.string "title",       limit: 255
    t.string "artist",      limit: 255
    t.string "description", limit: 255
  end

  create_table "nerve_cache", force: :cascade do |t|
    t.string   "external_id",   limit: 255
    t.datetime "creation_date"
    t.string   "track",         limit: 255
    t.string   "artist",        limit: 255
    t.string   "album",         limit: 255
    t.integer  "explicit",      limit: 4,     default: 0
    t.text     "big",           limit: 65535
    t.text     "lyrics",        limit: 65535
    t.integer  "genre",         limit: 4
    t.integer  "year",          limit: 4
  end

  create_table "playlist_tracks", id: false, force: :cascade do |t|
    t.integer "playlist_id", limit: 4, null: false
    t.integer "track_id",    limit: 4, null: false
  end

  create_table "playlists", force: :cascade do |t|
    t.integer  "created_by",    limit: 4,  null: false
    t.datetime "creation_date",            null: false
    t.string   "name",          limit: 64
  end

  create_table "settings", force: :cascade do |t|
    t.string "key",   limit: 255,   null: false
    t.text   "value", limit: 65535
  end

  add_index "settings", ["key"], name: "index_settings_on_key", unique: true, using: :btree

  create_table "track_comments", force: :cascade do |t|
    t.integer  "track_id",      limit: 4,     null: false
    t.integer  "created_by",    limit: 4,     null: false
    t.datetime "creation_date",               null: false
    t.text     "comment",       limit: 65535
  end

  create_table "track_idents", id: false, force: :cascade do |t|
    t.integer "track_id",   limit: 4,   null: false
    t.string  "type",       limit: 32,  null: false
    t.string  "identifier", limit: 255, null: false
  end

  add_index "track_idents", ["identifier"], name: "in_ident", using: :btree

  create_table "tracks", force: :cascade do |t|
    t.integer  "external_id",         limit: 4
    t.string   "title",               limit: 255
    t.integer  "artist",              limit: 4,                                             null: false
    t.integer  "album",               limit: 4,                                             null: false
    t.integer  "status",              limit: 4
    t.integer  "approved_by",         limit: 4,                             default: 0
    t.integer  "main_genre",          limit: 4,                             default: 0
    t.integer  "created_by",          limit: 4,                                             null: false
    t.datetime "creation_date"
    t.datetime "last_update"
    t.datetime "local_kill_date"
    t.string   "local_path",          limit: 255
    t.decimal  "intro_start",                       precision: 6, scale: 2
    t.decimal  "intro_end",                         precision: 6, scale: 2
    t.decimal  "hook_end",                          precision: 6, scale: 2
    t.decimal  "hook_start",                        precision: 6, scale: 2
    t.decimal  "outro",                             precision: 6, scale: 2
    t.boolean  "waveform",                                                  default: false
    t.decimal  "length",                            precision: 6, scale: 2,                 null: false
    t.integer  "bitrate",             limit: 4,                             default: 0
    t.integer  "sample_rate",         limit: 4,                             default: 0
    t.integer  "end_type",            limit: 4,                             default: 0
    t.boolean  "explicit",                                                  default: false
    t.boolean  "is_library",                                                default: false
    t.boolean  "is_automation",                                             default: false
    t.string   "ext_id",              limit: 255
    t.string   "playout_id",          limit: 255
    t.integer  "restrict_play",       limit: 4,                             default: 0
    t.string   "note",                limit: 255
    t.boolean  "flagged",                                                   default: false
    t.boolean  "instrumental",                                              default: false
    t.string   "playout_id_2",        limit: 255
    t.text     "extra",               limit: 65535
    t.integer  "category_a",          limit: 4
    t.integer  "category_b",          limit: 4
    t.string   "local_path_preview",  limit: 255
    t.string   "local_path_waveform", limit: 255
  end

  add_index "tracks", ["title"], name: "index_tracks_on_title", type: :fulltext

  create_table "users", force: :cascade do |t|
    t.string  "external_ref", limit: 255
    t.integer "agree_terms",  limit: 4,     default: 0
    t.text    "permissions",  limit: 65535
    t.integer "is_admin",     limit: 4,     default: 0
    t.string  "username",     limit: 255
    t.string  "name",         limit: 255
    t.string  "playout",      limit: 255
    t.integer "is_moderator", limit: 4,     default: 0
  end

end
