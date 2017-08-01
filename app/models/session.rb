class Session < ActiveRecord::Base
    serialize :weeks
    validates_presence_of :time
    validates_presence_of :day
    validates_presence_of :weeks
end
