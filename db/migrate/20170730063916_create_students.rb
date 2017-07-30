class CreateStudents < ActiveRecord::Migration
    def change
        create_table :students do |t|
            t.text :enrolments
            t.timestamps null: false
        end
    end
end
