# Use python2
# Data
# Use this class to collect all the scattered csv file data into
# a format with can use later tht matches our database
#
# Authors:
# Jacob Gonzalez
# .

import csv

# course classthat fits the ruby model
class Course:
    def __init__(self, id, name, catalog_number):
        self.id = id
        self.name = name
        self.catalog_number = catalog_number

    # print as a csv row
    def __repr__(self):
        return '"%s","%s","%s"' % (self.id, self.name, self.catalog_number)

    # test equality against another course
    def __eq__(self, other):
        return self.id == other.id

# import courses from the course catalog
def importCourses(filename):
    courses = []
    with open(filename) as f:
        reader = csv.reader(f)
        for row in reader:
            id = row[1]
            name = row[4]
            course = Course(id, name, None)
            courses.append(course)
    return courses

# fill offering cataglog numbers from the offerings csv
def fillCourseOfferings(filename, courses):
    with open(filename) as f:
        reader = csv.reader(f)
        for row in reader:
            id = row[1]
            for course in courses:
                if course.id == id:
                    # COMPSCI 3005
                    course.catalog_number = '%s %s' % (row[4], row[5])
    return courses

# TODO: find a bettr place for the course csv files
courses = importCourses('../courses/CM_CRSE_CAT_ECMS-6383074.csv')
courses = fillCourseOfferings('../courses/CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv', courses)

# print them for now
for course in courses:
    print(course)
