module ClashRequestsHelper
    def session_item(item)
        displacement = [[((item[:session].time + 9.5.hours).hour - 8) * 100 + (item[:session].time + 9.5.hours).min * (100 / 60), 0].max, 1000].min
        height = [item[:session].length / 60 * 100, 0.5].max
        class_number = nil
        item[:session].component.class_numbers.each do |key, value|
            class_number = value if item[:session].component_code == key
        end
        clash_session = if item[:clashes].nil?
                            false
                        else
                            true
                        end
        largest_session = true
        if clash_session && item[:clashes][:max_class] != item[:session]
            largest_session = false
        end
        haml_tag :li, :class => ['session',
                                 ('requested' if item[:requested]),
                                 ('clash' if clash_session),
                                 ('smaller-class' unless largest_session),
                                 ('larger-class' if largest_session && clash_session)],
                      'data-course' => item[:id],
                      :style => "margin-top: #{displacement}px; height: #{height}px;" do
            haml_tag :a do
                haml_tag :span, "#{(item[:session].time + (9.5 * 60 * 60)).to_formatted_s(:time)} - #{(item[:session].time + (9.5 * 60 * 60) + item[:session].length.minutes).to_formatted_s(:time)}", class: 'event-date'
                haml_tag :em, item[:session].component_code, class: 'event-name'
                haml_tag :span, class_number, class: 'class-number'
            end
        end
    end
end
