console.log('loaded courses.js')

$(document).on('change','#semester_select', function () {
    console.log("semester change")
    update_subject_selection();
});

$(document).on('change','#subject_select', function () {
   update_course_selection();
});


$(document).on('change','#course_select', function () {
   //make_enrollment_component_selection();
   //make_related_component_selection();

   make_component_selection();
});

function change_subject_options(data) {
    $("#course_select").empty();
    console.log(data);
    for(var i = 0;i<data.length;i++){
        var newOption = $("<option/>").attr("value", data[i]);
        newOption.text(data[i]);
        $("#subject_select").append(newOption);
    }
};

function reset_course_selector() {
    $("#course_select").empty();
    var defaultOption = $("<option/>").attr("value", -1);
    defaultOption.text("Select a Course");
    $("#course_select").append(defaultOption);
};

function reset_subject_selector() {
    $("#subject_select").empty();
    var defaultOption = $("<option/>").attr("value", -1);
    defaultOption.text("Select a Subject");
    $("#subject_select").append(defaultOption);
}

function clear_subject_and_courses_and_sessions(data) {
     reset_subject_selector();
     $("#course_select").empty();
     clear_components_div();
};

function update_subject_selection() {
    var semester_time = $('#semester_select').val()
    var request = "/clash_resolution/find_subjects?semester_time=" + encodeURIComponent(semester_time);
    console.log(request);
    var aj = $.ajax({
        url: request,
        type: 'get'
    }).done(function (data) {
        clear_subject_and_courses_and_sessions(data);
        change_subject_options(data);
    }).fail(function (data) {
        console.log('AJAX request has FAILED');
    });
};

function update_course_selection(){
    var subject_area = $('#subject_select').val()
    var request = "/clash_resolution/find_courses_from_subject_area?area_code=" + encodeURIComponent(subject_area);
    console.log(request);
    var aj = $.ajax({
        url: request,
        type: 'get'
    }).done(function (data) {
        clear_components_div(data);
        change_courses_options(data);
    }).fail(function (data) {
        console.log('AJAX request has FAILED');
    });
};


function change_courses_options(data) {
    reset_course_selector();

    for(var i = 0;i<data.length;i++){
        var newOption = $("<option/>").attr("value", data[i].catalogue_number);
        newOption.text(data[i].catalogue_number);
        $("#course_select").append(newOption);
    }
};

function make_component_selection(){
    var selected_course_id = $('#course_select').val()
    var request = "/clash_resolution/find_components_and_sessions_from_course?selected_id=" + encodeURIComponent(selected_course_id);
    console.log("Attemping to change the components");
    console.log(request);
    var aj = $.ajax({
        url: request,
        type: 'get'
    }).done(function (data) {
        clear_components_div(data);
        make_component_select_boxes(data);
    }).fail(function (data) {
        console.log('AJAX request has FAILED');
    });
};

function clear_components_div(data) {
    while (component_div.firstChild) {
        component_div.removeChild(component_div.firstChild);
    }
}

function make_component_select_boxes(component_data) {
    for(var i = 0;i<component_data.length;i++){
        var selectList = document.createElement("select");

        var attvalue = "clash_resolution[" + component_data[i].component_name + "]";
        selectList.setAttribute("name", attvalue);


        var defaultOption = $("<option/>").attr("value", -1);
        defaultOption.text(component_data[i].component_name);
        $(selectList).append(defaultOption);

        for(var j = 0;j<component_data[i].component_sessions.length;j++){
            var newOption = $("<option/>").attr("value", component_data[i].component_sessions[j].id);
            newOption.text(component_data[i].component_sessions[j].component_code + ":" + component_data[i].component_sessions[j].id);
            $(selectList).append(newOption);
        }

        component_div.appendChild(selectList);
        component_div.appendChild(document.createElement('br'));

    }
};
