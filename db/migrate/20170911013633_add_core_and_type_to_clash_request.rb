class AddCoreAndTypeToClashRequest < ActiveRecord::Migration
  def change
    add_column :clash_requests, :core, :string
    add_column :clash_requests, :request_type, :string
    add_column :clash_requests, :email, :string
  end
end
