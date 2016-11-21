class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

    has_many :contacts

    def check_contact_email(email)
        contacts.find_by(email: email).nil?
    end

    def check_other_emails(id, email)
        contacts.where.not(id: id).find_by(email: email).nil?
    end
end