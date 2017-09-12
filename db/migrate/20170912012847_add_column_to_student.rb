class AddColumnToStudent < ActiveRecord::Migration
    def change
        add_column :students, :name, :string
        add_column :students, :email, :string
    end
end
