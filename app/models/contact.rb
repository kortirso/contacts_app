class Contact < ApplicationRecord
    belongs_to :user

    validates :user_id, :name, :email, presence: true
end
