class ClashResolution < ActiveRecord::Base
    def self.getSessionData(current_session)
        if(current_session)
            return current_session
        end
        # create an empty hash and return
        result = Hash.new();
        hash = Hash.new();
        result["clash_resolution"] = hash
        return result
    end
end
