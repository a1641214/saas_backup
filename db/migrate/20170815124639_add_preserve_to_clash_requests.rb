class AddPreserveToClashRequests < ActiveRecord::Migration
    def change
        # text values are serialized to arrays
        add_column :clash_requests, :preserve_clash_sessions, :text
        add_column :clash_requests, :preserve_clash_course, :integer
        add_column :clash_requests, :preserve_student_sessions, :text
        add_column :clash_requests, :preserve_student_courses, :text
    end
end
