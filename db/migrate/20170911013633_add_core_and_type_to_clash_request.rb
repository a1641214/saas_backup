class AddCoreAndTypeToClashRequest < ActiveRecord::Migration
  def change
    add_column :clash_requests, :core, :string
    add_column :clash_requests, :request_type, :string
  end
end
