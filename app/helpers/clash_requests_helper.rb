module ClashRequestsHelper
    def session_item(item)
        displacement = [[((item[:session].time + 9.5.hours).hour - 8) * 100 + (item[:session].time + 9.5.hours).min * (100 / 60), 0].max, 1000].min
        height = [item[:session].length/60 * 100, 0.5].max
        haml_tag :li, :class => ['session', ('requested' if item[:requested])], 'data-course' => item[:id], :style => "margin-top: #{displacement}px; height: #{height}px;" do
            haml_tag :a do
                haml_tag :span, "#{(item[:session].time + (9.5*60*60)).to_formatted_s(:time)} - #{(item[:session].time + (9.5*60*60) + item[:session].length.minutes).to_formatted_s(:time)}", class: 'event-date'
                haml_tag :em, item[:session].component_code, class: 'event-name'
            end
        end
    end
end
