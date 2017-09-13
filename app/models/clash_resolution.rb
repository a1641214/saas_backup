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

    def self.box_selected?(value)
        return true if value == 1
        false
    end

    def self.convert_request_type(parameters)
        type = Array.new
        if parameters['clash_resolution']
            type.append('Timetable Clash')
        end
        if parameters['unit_overload']
            type.append('Unit Overload' )
        end
        if parameters['class_full']
            type.append('Clash Full' )
        end
        type
    end

    def self.extend_to_full_request(parameters)
        # add submit date
        Time.zone = 'Adelaide'
        time = Time.zone.now
        parameters = parameters.merge(date_submitted: time.to_date)
        ## add "is core course" boolean type
        core = false
        core = true if parameters['core_yes']
        parameters = parameters.merge(core: core)
        # add request type
        type = convert_request_type(parameters)
        parameters = parameters.merge(request_type: type)
        # link course with clash request
        id = Course.where(catalogue_number: parameters[:course]).first.id
        parameters = parameters.merge(course_id: id)
        return parameters
    end
end
