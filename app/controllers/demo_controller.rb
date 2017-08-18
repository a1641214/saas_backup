require 'import_file'
class DemoController < ApplicationController
    def index
        @path = 'db/csv/'
        @courses = ImportFile.import_courses(@path + 'CM_CRSE_CAT_ECMS-6383074.csv')
        ImportFile.fill_course_offerings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', @courses)
        ImportFile.import_components_and_link(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv', @courses)

        return unless Course.count.zero?

        # push courses into database objects
        @courses.each do |course|
            # create a course entry
            c = Course.create(id: course.id,
                              name: course.name,
                              catalogue_number: course.catalog_number)

            # create components and link to the courses
            course.components.each do |component|
                comp = Component.create(class_type: component.type)
                c.components.push(comp)
            end
        end

        # push sessions into database objects
        sessions = ImportFile.import_sessions(@path + 'SPActivity_2017.csv')
        sessions.each do |session|
            begin
                course = Course.find(session.course_id)
                course.components.each do |component|
                    next unless component.class_type[0, 2] == session.component_code[0, 2]
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

    def display_student
        @path = 'db/csv/'
        @courses = ImportFile.import_courses(@path + 'CM_CRSE_CAT_ECMS-6383074.csv')
        @students = ImportFile.import_students(@path + 'EN_BY_CLASS_ECMS-6384857.csv')
        @classes = ImportFile.import_classes(@path + 'CLS_CMBND_SECT_FULL-6385825.csv')
        ImportFile.fill_course_offerings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', @courses)
        ImportFile.import_components_and_link(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv', @courses)
        ImportFile.fill_students_with_courses(@students, @classes, @courses)
    end

    def student_object
        @students.each do |student|
            Student.create(student.id)
        end
    end
end
