class Deal < ApplicationRecord
    enum status: {success: 1, failed: 0}
end
