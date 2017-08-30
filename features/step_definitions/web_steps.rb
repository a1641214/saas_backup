require 'mail'
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'paths'))
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'support', 'selectors'))

module WithinHelpers
    def with_scope(locator)
        locator ? within(*selector_for(locator)) { yield } : yield
    end
end
World(WithinHelpers)

# Single-line step scoper
When /^(.*) within (.*[^:])$/ do |step, parent|
    with_scope(parent) { When step }
end

Given(/^there is a student with id "([^"]*)"$/) do |student_id|
    create(:student, id: student_id)
end

# Multi-line step scoper
When /^(.*) within (.*[^:]):$/ do |step, parent, table_or_string|
    with_scope(parent) { When "#{step}:", table_or_string }
end

Given /^(?:|I )am on (.+)$/ do |page_name|
    visit path_to(page_name)
end

Given /^(?:|I )am logged in$/ do
    # TODO: Implement when authentication is completed (#21)
end

Given /^typical usage and data$/ do
    # Student Course
    course_enrol = FactoryGirl.create(:course)
    comp1_enrol = FactoryGirl.create(:component, class_type: 'Lecture')
    comp2_enrol = FactoryGirl.create(:component, class_type: 'Tutorial')
    course_enrol.components << comp1_enrol
    course_enrol.components << comp2_enrol

    # Enroled Sessions
    s1_e = FactoryGirl.create(:session, component_code: 'LE01', component: comp1_enrol)
    s2_e = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1_enrol)
    FactoryGirl.create(:session, component_code: 'TU01', component: comp2_enrol)
    s4_e = FactoryGirl.create(:session, component_code: 'TU02', component: comp2_enrol)

    # Clash Course
    course_clash = FactoryGirl.create(:course, catalogue_number: 'SOIL&WAT 1000WT', name: 'Soil and Water')
    comp1_clash = FactoryGirl.create(:component, class_type: 'Lecture')
    comp2_clash = FactoryGirl.create(:component, class_type: 'Practical')
    course_clash.components << comp1_clash
    course_clash.components << comp2_clash

    # Clashed Sessions
    s1_c = FactoryGirl.create(:session, component_code: 'LE01', component: comp1_clash)
    s2_c = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1_clash)
    FactoryGirl.create(:session, component_code: 'PR01', component: comp2_clash)
    s4_c = FactoryGirl.create(:session, component_code: 'PR02', component: comp2_clash)

    # Student
    student_one = create(:student, id: 1680000)
    student_one.courses << course_enrol
    student_one.sessions << s1_e << s2_e << s4_e
    student_one.save!

    # Clash Request
    clash_request = create(:clash_request, id: 5)
    clash_request.course = course_clash
    clash_request.sessions << s1_c << s2_c << s4_c
    clash_request.student = student_one

    clash_request.save!
    ClashRequest.rebuild_preserve(clash_request.id)
end

Given(/^student "([^"]*)" is enrolled in courses "([^"]*)" and "([^"]*)"$/) do |in_id, course1, course2|
    course_one = FactoryGirl.create(:course, catalogue_number: course1)
    course_two = FactoryGirl.create(:course, catalogue_number: course2)
    comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
    comp2 = FactoryGirl.create(:component, class_type: 'Tutorial')
    course_one.components << comp1
    course_one.components << comp2
    s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
    s2 = FactoryGirl.create(:session, component_code: 'LE01', day: 'Wednesday', component: comp1)
    FactoryGirl.create(:session, component_code: 'TU01', component: comp2)
    s4 = FactoryGirl.create(:session, component_code: 'TU02', component: comp2)
    student_one = Student.find in_id
    student_one = create(:student, id: in_id) unless student_one
    student_one.courses << course_one
    student_one.courses << course_two
    student_one.sessions << s1 << s2 << s4
    student_one.save!
end

Given(/^student "([^"]*)" is enrolled in sessions "([^"]*)" of type "([^"]*)" and "([^"]*)" of type "([^"]*)", with "([^"]*)" also offered for "([^"]*)"$/) do |in_id, session1, type1, session2, type2, extra_session, course|
    course_one = FactoryGirl.create(:course, catalogue_number: course)
    comp1 = FactoryGirl.create(:component, class_type: type1)
    comp2 = FactoryGirl.create(:component, class_type: type2)
    course_one.components << comp1
    course_one.components << comp2

    s1 = FactoryGirl.create(:session, component_code: session1, component: comp1)

    s3 = FactoryGirl.create(:session, component_code: session2, component: comp2)
    s4 = FactoryGirl.create(:session, component_code: extra_session, component: comp2)

    student_one = Student.find(in_id)
    student_one = create(:student, id: in_id) unless student_one
    student_one.courses << course_one
    student_one.sessions << s1 << s3 << s4
    student_one.save!
end

Given /^there is a clash request in the database$/ do
    create(:clash_request)
end

Given /^there is a clash request with the following:$/ do |fields|
    clash_request = create(:clash_request)
    clash_request.update!(fields.rows_hash)
    ClashRequest.rebuild_preserve(clash_request.id)
end

Given(/^clash request "([^"]*)" is resolving the course "([^"]*)"$/) do |clash_id, course_code|
    clash_request = ClashRequest.find(clash_id)
    clash_course = create(:course, catalogue_number: course_code)
    clash_request.course = clash_course
    clash_request.save!
    ClashRequest.rebuild_preserve(clash_request.id)
end

Given(/^clash request "([^"]*)" is resolving the course "([^"]*)" with default sessions and components$/) do |clash_id, course_code|
    clash_request = ClashRequest.find(clash_id)
    clash_course = create(:course, catalogue_number: course_code)
    clash_request.course = clash_course
    comp1 = FactoryGirl.create(:component, class_type: 'Lecture')
    comp2 = FactoryGirl.create(:component, class_type: 'Practical')
    clash_course.components << comp1
    clash_course.components << comp2

    s1 = FactoryGirl.create(:session, component_code: 'LE01', component: comp1)
    FactoryGirl.create(:session, component_code: 'PR01', component: comp2)
    s3 = FactoryGirl.create(:session, component_code: 'PR02', component: comp2)
    clash_request.sessions << s1 << s3
    clash_request.save!
    ClashRequest.rebuild_preserve(clash_request.id)
end

Given /^student "([^"]*)" is enrolled in the following course:$/ do |student_id, table|
    student = Student.find(student_id)
    create(:course)
    course = update!(table.rows_hash)
    student.courses << course
    student.save!
    course.save!
end

Given /^there is a clash request for the student "([^"]*)" with the following:$/ do |student_id, table|
    student_one = create(:student, id: student_id)
    clash_request = create(:clash_request, student: student_one)
    clash_request.update!(table.rows_hash)
    clash_request.save!
    student.save!
    ClashRequest.rebuild_preserve(clash_request.id)
end

When /^(?:|I )go to (.+)$/ do |page_name|
    visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
    click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
    click_link(link)
end

When /^(?:|I )fill in "([^"]*)" with "([^"]*)"$/ do |field, value|
    fill_in(field, with: value)
end

When /^(?:|I )fill in "([^"]*)" for "([^"]*)"$/ do |value, field|
    fill_in(field, with: value)
end

# Use this to fill in an entire form with data from a table. Example:
#
#   When I fill in the following:
#     | Account Number | 5002       |
#     | Expiry date    | 2009-11-01 |
#     | Note           | Nice guy   |
#     | Wants Email?   |            |
#
# TODO: Add support for checkbox, select or option
# based on naming conventions.
#
When /^(?:|I )fill in the following:$/ do |fields|
    fields.rows_hash.each do |name, value|
        When %(I fill in "#{name}" with "#{value}")
    end
end

When /^(?:|I )select "([^"]*)" from "([^"]*)"$/ do |value, field|
    select(value, from: field)
end

When /^(?:|I )check "([^"]*)"$/ do |field|
    check(field)
end

When /^(?:|I )uncheck "([^"]*)"$/ do |field|
    uncheck(field)
end

When /^(?:|I )choose "([^"]*)"$/ do |field|
    choose(field)
end

When /^(?:|I )attach the file "([^"]*)" to "([^"]*)"$/ do |path, field|
    attach_file(field, File.expand_path(path))
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
    if page.respond_to? :should
        expect(page).to have_content(text)
    else
        assert page.has_content?(text)
    end
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
        page.should have_xpath('//*', text: regexp)
    else
        assert page.has_xpath?('//*', text: regexp)
    end
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
    if page.respond_to? :should
        page.should have_no_content(text)
    else
        assert page.has_no_content?(text)
    end
end

Then(/^I should see "([^"]*)" selected for the course "([^"]*)" for the "([^"]*)"$/) do |comp_code, course, class_type|
    under_course = course.downcase.tr(' ', '_')
    under_course = under_course.upcase
    under_course.tr!('&', '_')
    expect(find(:css, 'select#' + under_course + '_' + class_type).value).to eq(comp_code)
end

When(/^I select "([^"]*)" for the course "([^"]*)" for the "([^"]*)"$/) do |comp_code, course, class_type|
    under_course = course.downcase.tr(' ', '_')
    under_course = under_course.upcase
    under_course.tr!('&', '_')
    select comp_code, from: under_course + '_' + class_type
end

Then(/^I should see "([^"]*)" as "([^"]*)" and "([^"]*)" for the course "([^"]*)"$/) do |class_type, org_comp, prop_comp, course|
    css_id = '#' + course.tr(' ', '_').tr('&', '_') + '_' + class_type
    expect(find(css_id)).to have_content(org_comp)
    expect(find(css_id)).to have_content(prop_comp)
end

Then /^(?:|I )should not see \/([^\/]*)\/$/ do |regexp|
    regexp = Regexp.new(regexp)

    if page.respond_to? :should
        page.should have_no_xpath('//*', text: regexp)
    else
        assert page.has_no_xpath?('//*', text: regexp)
    end
end

Then /^the "([^"]*)" field(?: within (.*))? should contain "([^"]*)"$/ do |field, parent, value|
    with_scope(parent) do
        field = find_field(field)
        field_value = field.tag_name == 'textarea' ? field.text : field.value
        if field_value.respond_to? :should
            field_value.should =~ /#{value}/
        else
            assert_match(/#{value}/, field_value)
        end
    end
end

Then /^the "([^"]*)" field(?: within (.*))? should not contain "([^"]*)"$/ do |field, parent, value|
    with_scope(parent) do
        field = find_field(field)
        field_value = field.tag_name == 'textarea' ? field.text : field.value
        if field_value.respond_to? :should_not
            field_value.should_not =~ /#{value}/
        else
            assert_no_match(/#{value}/, field_value)
        end
    end
end

Then /^the "([^"]*)" field should have the error "([^"]*)"$/ do |field, error_message|
    element = find_field(field)
    classes = element.find(:xpath, '..')[:class].split(' ')

    form_for_input = element.find(:xpath, 'ancestor::form[1]')
    using_formtastic = form_for_input[:class].include?('formtastic')
    error_class = using_formtastic ? 'error' : 'field_with_errors'

    if classes.respond_to? :should
        classes.should include(error_class)
    else
        assert classes.include?(error_class)
    end

    if page.respond_to?(:should)
        if using_formtastic
            error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
            error_paragraph.should have_content(error_message)
        else
            page.should have_content("#{field.titlecase} #{error_message}")
        end
    elsif using_formtastic
        error_paragraph = element.find(:xpath, '../*[@class="inline-errors"][1]')
        assert error_paragraph.has_content?(error_message)
    else
        assert page.has_content?("#{field.titlecase} #{error_message}")
    end
end

Then /^the "([^"]*)" field should have no error$/ do |field|
    element = find_field(field)
    classes = element.find(:xpath, '..')[:class].split(' ')
    if classes.respond_to? :should
        classes.should_not include('field_with_errors')
        classes.should_not include('error')
    else
        assert !classes.include?('field_with_errors')
        assert !classes.include?('error')
    end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should be checked$/ do |label, parent|
    with_scope(parent) do
        field_checked = find_field(label)['checked']
        if field_checked.respond_to? :should
            field_checked.should be_true
        else
            assert field_checked
        end
    end
end

Then /^the "([^"]*)" checkbox(?: within (.*))? should not be checked$/ do |label, parent|
    with_scope(parent) do
        field_checked = find_field(label)['checked']
        if field_checked.respond_to? :should
            field_checked.should be_false
        else
            assert !field_checked
        end
    end
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
    current_path = URI.parse(current_url).path
    if current_path.respond_to? :should
        expect(current_path).to eq(path_to(page_name))
    else
        assert_equal path_to(page_name), current_path
    end
end

Then /^(?:|I )should have the following query string:$/ do |expected_pairs|
    query = URI.parse(current_url).query
    actual_params = query ? CGI.parse(query) : {}
    expected_params = {}
    expected_pairs.rows_hash.each_pair { |k, v| expected_params[k] = v.split(',') }

    if actual_params.respond_to? :should
        actual_params.should == expected_params
    else
        assert_equal expected_params, actual_params
    end
end

Then /^show me the page$/ do
    save_and_open_page
end

Then /^there should be ([0-9]+) row(?:|s)$/ do |rows|
    within('tbody') do
        expect(all('tr').count).to eq(rows.to_i)
    end
end
