# Use this class to collect all the scattered csv file data into
# a format with can use later that matches our database
#
# Authors:
# Jacob Gonzalez
# Markus Andersons
# Zetong Wang
# Huey Min Gan

require 'csv'
require 'import_file'

def import_students(students, classes)
    students.each do |student|
        stud = Student.create(id: student.id)
        student.class_numbers.each_with_index do |stud_class, index|
            classes.each do |a_class|
                next unless stud_class == a_class.class_nbr && student.terms[index] == a_class.term
                # find associated course
                course = Course.find(a_class.course_id)
                stud.courses << course unless stud.courses.select { |c| c.id == a_class.course_id }.count != 0

                # find associated sessions
                course.components.each do |course_component|
                    next unless course_component.class_type[0, 2] == a_class.section[0, 2]
                    sessions = course_component.sessions.select { |s| s.component_code == a_class.section }
                    stud.sessions << sessions if sessions.count != 0
                end
            end
        end
    end
end

def execute_import
    Component.destroy_all
    Course.destroy_all
    Session.destroy_all
    Student.destroy_all

    # modifier specifies the path for the reduced dataset. use empty string for full set
    modifier = '.min'
    @path = 'db/csv/'
    @courses = ImportFile.import_courses(@path + 'CM_CRSE_CAT_ECMS-6383074' + modifier + '.csv')
    ImportFile.fill_course_offerings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', @courses)
    ImportFile.import_components_and_link(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069' + modifier + '.csv', @courses)
    sessions = ImportFile.import_sessions(@path + 'SPActivity_2017' + modifier + '.csv')
    students = ImportFile.import_students(@path + 'EN_BY_CLASS_ECMS-6384857' + modifier + '.csv')
    classes = ImportFile.import_classes(@path + 'CLS_CMBND_SECT_FULL-6385825' + modifier + '.csv')

    # using activerecord-import to batch create objects to avoid N+1 problem
    batch_courses = []
    batch_sessions = []

    # push courses into database objects
    @courses.each do |_, course|
        # create a course entry
        c = Course.new(id: course.id,
                       name: course.name,
                       catalogue_number: course.catalog_number)
        batch_courses << c
    end
    Course.import batch_courses

    # push components into database
    @courses.each do |_, course|
        # create a course entry
        c = Course.find(course.id.to_i)

        # create components and link to the courses
        course.components.each do |component|
            comp = Component.create(class_type: component.type, class_numbers: {})
            comp_classes = classes.select { |cl| component.type[0, 2] == cl.section[0, 2] && cl.course_id.to_i == course.id.to_i }
            comp_classes.each do |cl|
                comp.class_numbers[cl.section] = cl.class_nbr
            end
            comp.courses << c
            comp.save!
        end
    end

    # push sessions into database objects
    sessions.each do |session|
        begin
            course = Course.find(session.course_id)
            course.components.each do |component|
                next unless component.class_type[0, 2] == session.component_code[0, 2]
                s = Session.new(component: component,
                                time: session.time,
                                day: session.day,
                                weeks: session.weeks,
                                length: session.length,
                                capacity: session.capacity,
                                component_code: session.component_code)
                batch_sessions << s
            end
        rescue ActiveRecord::RecordNotFound
            puts 'Course with id ' + session.course_id.to_s + ' does not exist!'
        end
    end

    # batch create all the sessions from the arrays
    Session.import batch_sessions

    # import students and link
    import_students(students, classes)
end

namespace :import do
    desc 'Import Files'
    task mail: :environment do
        next if Mail.all.empty?
        Mail.all.each { |mail| EnrolmentMailer.receive(mail) }
        execute_import
    end
    task run: :environment do
        execute_import
    end
end
