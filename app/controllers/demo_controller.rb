require 'ImportFile'
class DemoController < ApplicationController
    def index
        @path = "db/csv/"
        @courses = ImportFile.importCourses(@path + "CM_CRSE_CAT_ECMS-6383074.csv")
        ImportFile.fillCourseOfferings(@path + 'CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv',@courses)
        ImportFile.importComponentsAndLink(@path + 'CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv',@courses)
    end
end
