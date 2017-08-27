class ClashResolution < ActiveRecord::Base
    def self.getSessionData(current_session)
        if(current_session)
            return current_session
        end
        # create an empty hash and return
        result = Hash.new();
        hash = Hash.new();
        result["clash_resolution"] = hash
        return result
    end
    
    def self.isValid(txt)
        txt.each_byte do |i|
            if( !(47 < i and i < 58) )
                return false
            end
        end
        return true
    end

    def self.isStudentExist(student_id)
        student = Student.where(:id => student_id)
        if(student.size == 0)
            return false
        end
        return true
    end

    
    def self.checkParameters(parameters)
        form =  parameters[:clash_resolution]
        if ( ! parameters[:agree] )
            return "You have to confirm you approve and understand all conditions."
        end
        if( form[:name].length == 0 || form[:student_id] == 0 || 
            form[:email].length == 0 || form[:enrolment_request_id].length == 0
        )
            return "Please fill in all required information."
        end
        if ( !isValid(form[:enrolment_request_id]) ||  form[:enrolment_request_id].length > 9 )
            return "Invalid enrolment request id"
        end
        if ( !isValid(form[:student_id]) ||  form[:student_id].length > 9 )
            return "Invalid student id."
        end
        if( !isStudentExist(form[:student_id]))
            return "Student id does not exist on database."
        end
        return nil
    end
end
