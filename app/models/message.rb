class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :user
    validates :body,  length: { minimum: 1 }

    after_create_commit ->{
        broadcast_append_to self.conversation,
        target: "messages_list"
    }
    
    def self.ransackable_attributes(auth_object=nil)
        ["id","body","conversation_id","user_id"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["conversation","user"]
    end
end
    