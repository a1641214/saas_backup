class CreateJoinTableForCoursesAndComponents < ActiveRecord::Migration
    def change
        create_join_table :courses, :components
    end
end
