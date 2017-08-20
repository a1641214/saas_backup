class ClashResolutionController < ApplicationController
    layout 'clash_resolution'
    def index
        @degrees = ["Accounting","Software Engineering","Finance","Electronic Electricity","Telecommunication"]
        @courses = Course.all
    end
end
