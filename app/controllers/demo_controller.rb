require 'ImportFile'
class DemoController < ApplicationController
    def index
        @path = "db/csv/"
        @courses = ImportFile.importCourses(@path + "CM_CRSE_CAT_ECMS-6383074.csv")
        ImportFile.fillCourseOfferings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv',@courses)
        ImportFile.importComponentsAndLink(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv',@courses)
    end
    
    def display_student 
        @path = "db/csv/"
        @courses = ImportFile.importCourses(@path + "CM_CRSE_CAT_ECMS-6383074.csv")
        @students = ImportFile.importStudents(@path + 'EN_BY_CLASS_ECMS-6384857.csv')
        @classes = ImportFile.importClasses(@path + 'CLS_CMBND_SECT_FULL-6385825.csv')
        ImportFile.fillCourseOfferings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv',@courses)
        ImportFile.importComponentsAndLink(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv',@courses)
        ImportFile.fillStudentsWithCourses(@students,@classes,@courses)
    end    
    
    def student_object
        @students.each do |student|
            Student.create(student.id) 
        end    
    end    
end
