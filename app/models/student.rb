class Student < ActiveRecord::Base
    has_and_belongs_to_many :courses
    has_and_belongs_to_many :sessions
end
