class Session < ActiveRecord::Base
    serialize :weeks
    belongs_to :component
    has_and_belongs_to_many :students
    has_and_belongs_to_many :clash_requests
    validates_presence_of :time, :day, :weeks, :component_code, :length, :capacity

    def self.all_request_student_sessions(clash, student)
        clash_sessions = []
        clash.sessions.each do |sess|
            clash_sessions << sess
        end
        student_sessions = []
        student.sessions.each do |sess|
            student_sessions << sess
        end
        clash_sessions.concat student_sessions
    end

    def self.week_conversion(binary_arry)
        binary_arry.join.to_i(2)
    end

    def self.day_conversion(day)
        week_days = { 'Monday' => 1,
                      'Tuesday' => 2,
                      'Wednesday' => 4,
                      'Thursday' => 8,
                      'Friday' => 16,
                      'Saturday' => 32,
                      'Sunday' => 64 }
        week_days[day]
    end

    def self.two_session_clash(session_one, session_two)
        session_one_weeks = week_conversion(session_one.weeks)
        session_two_weeks = week_conversion(session_two.weeks)
        if (session_one_weeks & session_two_weeks) != 0 && session_one.day.eql?(session_two.day)
            session_one_start = session_one.time
            session_two_start = session_two.time
            session_one_end = (session_one.time + (3600 * session_one.length))
            session_two_end = (session_two.time + (3600 * session_two.length))
            if (session_one_end > session_two_start) && (session_one_end <= session_two_end) || (session_two_end > session_one_start) && (session_two_end <= session_one_end)
                return true
            end
        end
        false
    end

    def self.detect_clashes_weeks(session_array)
        clash_hash = {}

        session_array.each do |sess|
            temp_array = Array.new(52, 0)
            clash_hash[sess] = temp_array
        end
        session_array.each do |session_one|
            session_array.each do |session_two|
                next if session_one == session_two
                next unless two_session_clash(session_one, session_two)
                session_one_weeks = week_conversion(session_one.weeks)
                session_two_weeks = week_conversion(session_two.weeks)
                clash_integer = session_one_weeks & session_two_weeks
                updated_clashes_one = clash_hash[session_one].join.to_i(2) | clash_integer
                updated_clashes_two = clash_hash[session_two].join.to_i(2) | clash_integer
                clash_hash[session_one] = (0...updated_clashes_one.bit_length).map { |n| updated_clashes_one[n] }.reverse
                clash_hash[session_two] = (0...updated_clashes_two.bit_length).map { |n| updated_clashes_two[n] }.reverse
            end
        end
        clash_hash
    end

    def self.detect_clashes(session_array)
        clash_hash = {}
        session_array.each do |session_one|
            session_array.each do |session_two|
                next if session_one == session_two
                next unless two_session_clash(session_one, session_two)
                if clash_hash[session_one] == nil
                    clash_hash[session_one] = [session_two]
                else
                    clash_hash[session_one] = clash_hash[session_one].concat [session_two]
                end
                if clash_hash[session_two] == nil
                    clash_hash[session_two] = [session_one]
                else
                    clash_hash[session_two] = clash_hash[session_two].concat [session_one]
                end
            end
        end
        clash_hash
    end
end
