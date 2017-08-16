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

ActiveRecord::Schema.define(version: 20170815124639) do

  create_table "clash_requests", force: :cascade do |t|
    t.string   "studentId"
    t.text     "comments"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "enrolment_request_id"
    t.date     "date_submitted"
    t.string   "faculty"
    t.boolean  "inactive",                  default: false
    t.boolean  "resolved",                  default: false
    t.integer  "course_id"
    t.integer  "student_id"
    t.text     "preserve_clash_sessions"
    t.integer  "preserve_clash_course"
    t.text     "preserve_student_sessions"
    t.text     "preserve_student_courses"
  end

  add_index "clash_requests", ["course_id"], name: "index_clash_requests_on_course_id"
  add_index "clash_requests", ["student_id"], name: "index_clash_requests_on_student_id"

  create_table "clash_requests_sessions", id: false, force: :cascade do |t|
    t.integer "clash_request_id", null: false
    t.integer "session_id",       null: false
  end

  create_table "components", force: :cascade do |t|
    t.string   "class_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "components_courses", id: false, force: :cascade do |t|
    t.integer "course_id",    null: false
    t.integer "component_id", null: false
  end

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "catalogue_number"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "courses_students", id: false, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "course_id",  null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.time     "time"
    t.string   "day"
    t.text     "weeks"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "component_id"
    t.string   "component_code"
    t.integer  "length"
    t.integer  "capacity"
  end

  add_index "sessions", ["component_id"], name: "index_sessions_on_component_id"

  create_table "sessions_students", id: false, force: :cascade do |t|
    t.integer "student_id", null: false
    t.integer "session_id", null: false
  end

  create_table "students", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
