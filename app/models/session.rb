class Session < ActiveRecord::Base
    serialize :weeks
    belongs_to :component
    has_and_belongs_to_many :students
    has_and_belongs_to_many :clash_requests
    validates_presence_of :time, :day, :weeks, :component_code, :length, :capacity


    def self.all_request_student_sessions(clash, student)
        all_sessions = []
        clash.sessions.each do |sess|
            all_sessions << sess
        end
        student.sessions.each do |sess|
            all_sessions << sess
        end
        return all_sessions
    end
end
