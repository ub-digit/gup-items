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

ActiveRecord::Schema.define(version: 20150323104732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments2people2publications", force: :cascade do |t|
    t.integer  "people2publication_id"
    t.text     "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people2publications", force: :cascade do |t|
    t.integer  "publication_id"
    t.integer  "person_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "publication_types", force: :cascade do |t|
    t.text     "publication_type_code"
    t.text     "content_type"
    t.text     "form_template"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "label"
  end

  create_table "publications", force: :cascade do |t|
    t.text     "title"
    t.text     "author"
    t.integer  "pubyear"
    t.text     "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "issn"
    t.text     "isbn"
    t.integer  "publication_type_id"
    t.text     "alt_title"
    t.text     "publanguage"
    t.text     "extid"
    t.text     "links"
    t.text     "url"
    t.text     "category_hsv_local"
    t.text     "keywords"
    t.text     "pub_notes"
    t.text     "sourcetitle"
    t.text     "sourcevolume"
    t.text     "sourceissue"
    t.text     "sourcepages"
    t.text     "project"
    t.text     "eissn"
    t.text     "extent"
    t.text     "publisher"
    t.text     "place"
    t.text     "series"
    t.text     "artwork_type"
    t.text     "dissdate"
    t.text     "disstime"
    t.text     "disslocation"
    t.text     "dissopponent"
    t.text     "patent_applicant"
    t.text     "patent_application_number"
    t.text     "patent_application_date"
    t.text     "patent_number"
    t.text     "patent_date"
    t.text     "article_number"
    t.boolean  "is_draft"
    t.integer  "pubid",                     limit: 8
    t.boolean  "is_deleted"
    t.text     "created_by"
    t.text     "updated_by"
  end

end
