class JoinStudentsSessionsCoursesComponentsClashRequests < ActiveRecord::Migration
    def change
        create_join_table :clash_requests, :sessions
        add_reference :clash_requests, :course, index: true, foreign_key: true
        add_reference :clash_requests, :student, index: true, foreign_key: true
    end
end
