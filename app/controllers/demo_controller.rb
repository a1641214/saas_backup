require 'ImportFile'
class DemoController < ApplicationController
    def index
        @path = 'db/csv/'
        @courses = ImportFile.importCourses(@path + 'CM_CRSE_CAT_ECMS-6383074.csv')
        ImportFile.fillCourseOfferings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', @courses)
        ImportFile.importComponentsAndLink(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv', @courses)
        sessions = ImportFile.import_sessions(@path + 'SPActivity_2017.csv')
        sessions.each do |session|
            begin
                course = Course.find(session.course_id)
                course.components.each do |component|
                    next unless component.type[0, 2] == session.component_code[0, 2]
                    Session.create(component: component,
                                   time: session.time,
                                   day: session.day,
                                   weeks: session.weeks,
                                   length: session.length,
                                   capacity: session.capacity,
                                   component_code: session.component_code)
                end
            rescue ActiveRecord::RecordNotFound
                puts 'Course with id ' + session.course_id.to_s + ' does not exist!'
            end
        end
    end
end
