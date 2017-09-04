class DemoController < ApplicationController
    def index
        @courses = Course.all
    end
end
