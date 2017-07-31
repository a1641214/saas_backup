class CreateJoinTablesForStudents < ActiveRecord::Migration
    def change
        create_join_table :students, :sessions
        create_join_table :students, :courses
    end
end
