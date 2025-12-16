class Item < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :categories

    enum status: {pending: 0, available: 1,sold: 2}
    enum condition: {new: 0, small_defect: 1, damaged: 2}
end
