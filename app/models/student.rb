class Student < ActiveRecord::Base
    serialize :enrolments
end
