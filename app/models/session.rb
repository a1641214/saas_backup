class Session < ActiveRecord::Base
    serialize :weeks
    belongs_to :component
    validates_presence_of :time, :day, :weeks
end
