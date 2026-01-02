class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :user
    
        def self.ransackable_attributes(auth_object=nil)
        ["id","body","conversation_id","user_id"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["conversation","user"]
    end
end
    