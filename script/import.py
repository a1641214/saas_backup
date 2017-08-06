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
        self.components = []

    # print as a csv row
    def __repr__(self):
        return '"%s","%s","%s"' % (self.id, self.name, self.catalog_number)

    # test equality against another course
    def __eq__(self, other):
        return self.id == other.id

# component links courses and sessions
# e.g. LEC, TUT, etc
class Component:
    def __init__(self, id, type):
        self.id = id
        self.type = type

    def __repr__(self):
        return '"%s"' % self.type

    def __eq__(self, other):
        return self.type == other.type

# import courses from the course catalog
def importCourses(filename):
    courses = {}
    with open(filename) as f:
        reader = csv.reader(f)
        # each row is a new course
        for row in reader:
            id = row[1]
            name = row[4]
            course = Course(id, name, None)
            courses[id] = course
    return courses

# fill offering cataglog numbers from the offerings csv
def fillCourseOfferings(filename, courses):
    with open(filename) as f:
        reader = csv.reader(f)
        for row in reader:
            id = row[1]
            if id in courses:
                # COMPSCI 3005
                courses[id].catalog_number = '%s %s' % (row[4], row[5])

# read in all the components and link them to their courses
def importComponentsAndLink(filename, courses):
    components = []
    with open(filename) as f:
        reader = csv.reader(f)
        for row in reader:
            id = row[1]
            type = row[-1]
            component = Component(id, type)
            # link component and course
            if id in courses:
                course = courses[id]
                if component not in course.components:
                    courses[id].components.append(component)
                    components.append(component)

    return components

directory = raw_input('directory? ')

# TODO: find a bettr place for the course csv files
courses = importCourses('%s/CM_CRSE_CAT_ECMS-6383074.csv' % directory)
fillCourseOfferings('%s/CM_CRSE_CAT_ECMS_OFFERINGS-6383075.csv' % directory, courses)
components = importComponentsAndLink('%s/CM_CRSE_CAT_ECMS_COMPONENTS-6383069.csv' % directory, courses)

# print them for now
for course in courses.itervalues():
    print(course)
    print('\t%s' % course.components)
