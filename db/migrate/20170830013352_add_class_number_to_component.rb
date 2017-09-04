class AddClassNumberToComponent < ActiveRecord::Migration
    def change
        add_column :components, :class_numbers, :text
    end
end
