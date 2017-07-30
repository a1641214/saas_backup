class CreateClashRequests < ActiveRecord::Migration
  def change
    create_table :clash_requests do |t|
      t.string :studentId
      t.text :comments

      t.timestamps null: false
    end
  end
end
