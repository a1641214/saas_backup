class Course < ActiveRecord::Base
    validates_presence_of :name
    validates_presence_of :catalogue_number
end
