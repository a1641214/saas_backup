class UpdateColumnsForStudentAndSessions < ActiveRecord::Migration
    def change
        add_column :sessions, :component_code, :string
        remove_column :students, :enrolments
    end
end
