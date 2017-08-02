class AddColumnsToClashRequest < ActiveRecord::Migration
    def change
        add_column :clash_requests, :enrolment_request_id, :integer
        add_column :clash_requests, :date_submitted, :date
        add_column :clash_requests, :faculty, :string
        add_column :clash_requests, :inactive, :boolean, default: false
        add_column :clash_requests, :resolved, :boolean, default: false
    end
end
