class AddComponentToSessions < ActiveRecord::Migration
    def change
        add_reference :sessions, :component, index: true, foreign_key: true
    end
end
