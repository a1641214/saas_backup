class Course < ActiveRecord::Base
    validates_presence_of :name, :catalogue_number
    has_and_belongs_to_many :components
    has_and_belongs_to_many :students
end
