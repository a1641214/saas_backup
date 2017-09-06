class Course < ActiveRecord::Base
    validates_presence_of :name, :catalogue_number
    has_and_belongs_to_many :components
    has_and_belongs_to_many :students
    has_many :clash_requests

    def alternate_sessions(current_student, comp)
        target_component = components.where(id: comp.id).first
        alt_sessions = target_component.sessions
        arr = []
        arr << current_student.current_session(comp)
        alt_sessions.each do |sess|
            arr << sess.component_code unless arr.include?(sess.component_code)
        end
        arr
    end

    def alternate_sessions_clash_course(cl_request, comp)
        target_component = components.where(id: comp.id).first
        alt_sessions = target_component.sessions
        arr = []
        arr << cl_request.current_clash_session(comp)
        alt_sessions.each do |sess|
            arr << sess.component_code unless arr.include?(sess.component_code)
        end
        arr
    end

    def long_name
        "#{catalogue_number} #{name}"
    end


    def self.all_subject_areas()
        all_courses = Course.all
        subject_areas = []
        all_courses.each do |course|
            code = course.catalogue_number
            code_parts = code.split
            subject_string = ""
            code_parts.each do |part|
                unless part[0] =~ /[0-9]/
                    subject_string += (" " + part)
                end
            end
            subject_string[0] = ''
            unless subject_areas.include?(subject_string)
                subject_areas << subject_string
            end
        end
        subject_areas.sort!
    end

    def self.search_by_area(area)
        select_courses = Course.where("catalogue_number LIKE ?", "#{area}%").order(:catalogue_number)
        return select_courses
    end

    def self.search_components_by_course_and_get_sessions(in_id)
        course = Course.where(id: in_id).first
        return course.components
    end
end

