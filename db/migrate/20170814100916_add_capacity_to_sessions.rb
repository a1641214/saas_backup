class AddCapacityToSessions < ActiveRecord::Migration
    def change
        add_column :sessions, :capacity, :integer
    end
end
