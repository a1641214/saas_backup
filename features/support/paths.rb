module NavigationHelpers
    def path_to(page_name)
        case page_name

        when /^the home\s?page$/
            '/'

        when /^the clash requests list page$/
            '/requests'

        when /^the clash request create page$/
            '/requests/create'

        else
            begin
                page_name =~ /^the (.*) page$/
                path_components = Regexp.last_match(1).split(/\s+/)
                send(path_components.push('path').join('_').to_sym)
            rescue NoMethodError, ArgumentError
                raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
                      "Now, go and add a mapping in #{__FILE__}"
            end
        end
    end
end

World(NavigationHelpers)
