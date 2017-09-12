class ClashResolution < ActiveRecord::Base
    def self.get_session_data(current_session)
        return current_session if current_session
        # create an empty hash and return
        result = {}
        hash = {}
        result['clash_resolution'] = hash
        result
    end

    def self.valid?(txt)
        txt.each_byte do |i|
            return false unless i > 47 && i < 58
        end
        true
    end

    def self.student_exist?(student_id)
        student = Student.where(id: student_id)
        return false if student.empty?
        true
    end

    def self.check_parameters2(form)
        if form[:name].empty? || form[:student_id].empty? ||
           form[:email].empty? || form[:enrolment_request_id].empty?
            return 'Please fill in all required information.'
        end
        if !valid?(form[:enrolment_request_id]) || form[:enrolment_request_id].length > 9
            return 'Invalid enrolment request id'
        end
        nil
    end

    def self.check_parameters(parameters)
        form = parameters[:clash_resolution]
        unless parameters[:agree]
            return 'You have to confirm you approve and understand all conditions.'
        end
        error = check_parameters2(form)
        return error unless error.nil?
        if !valid?(form[:student_id]) || form[:student_id].length > 9
            return 'Invalid student id.'
        end
        unless student_exist?(form[:student_id])
            return 'Student id does not exist in database.'
        end
        nil
    end

    def self.isTrue(value)
        if value == 1
            return true
        end
        return false
    end

    def self.convertType(parameters)
        type = ""
        if parameters[:clash_resolution]["clash_resolution"]
            type = type + "Timetable Clash";
        end
        if parameters[:clash_resolution]["unit_overload"]
            type = type + ", Unit Overload";
        end
        if parameters[:clash_resolution]["class_full"]
            type = type + ", Class Full";
        end
        return type
    end
end
