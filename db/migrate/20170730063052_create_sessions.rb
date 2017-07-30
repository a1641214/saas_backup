class CreateSessions < ActiveRecord::Migration
    def change
        create_table :sessions do |t|
            t.time :time
            t.string :day
            t.text :weeks
            t.timestamps null: false
        end
    end
end
