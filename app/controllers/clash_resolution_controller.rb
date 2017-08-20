class ClashResolutionController < ApplicationController
    layout 'clash_resolution'
    def index
        @degrees = ["aaa","bbbb","cccccc"]
        @courses = Course.all
    end
end
