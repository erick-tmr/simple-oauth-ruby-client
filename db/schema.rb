# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_07_24_202136) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "auth_code_flows", force: :cascade do |t|
    t.text "issuer"
    t.text "client_id"
    t.text "code"
    t.text "requested_scope"
    t.text "granted_scope"
    t.text "access_token"
    t.text "id_token"
    t.text "refresh_token"
    t.text "auth_code_req_url"
    t.text "token_req_url"
    t.integer "expires_in"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
