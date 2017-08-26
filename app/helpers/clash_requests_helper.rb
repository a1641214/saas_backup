module ClashRequestsHelper
    def session_item(item)
        displacement = [[(item[:session].time.hour - 9) * 100 + item[:session].time.min * (100 / 60), 0].max, 1000].min
        height = [item[:session].length.minutes * (100 / 60), 50].max
        puts "Hour #{item[:session].time.hour} Min #{item[:session].time.min}"
        haml_tag :li, :class => 'session', 'data-course' => item[:id], :style => "margin-top: #{displacement}px; height: #{height}px;" do
            haml_tag :a do
                haml_tag :span, "#{item[:session].time.to_formatted_s(:time)} - #{(item[:session].time + item[:session].length.minutes).to_formatted_s(:time)}", class: 'event-date'
                haml_tag :em, item[:session].component_code, class: 'event-name'
            end
        end
    end
end
