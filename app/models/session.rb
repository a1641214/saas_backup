class Session < ActiveRecord::Base
    serialize :weeks
    belongs_to :component
    has_and_belongs_to_many :students
    has_and_belongs_to_many :clash_requests
    validates_presence_of :time, :day, :weeks, :component_code, :length
end
