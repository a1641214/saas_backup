class Component < ActiveRecord::Base
    serialize :class_numbers
    validates_presence_of :class_type
    has_many :sessions
    has_and_belongs_to_many :courses
end
