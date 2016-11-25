class User < ApplicationRecord
    devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

    has_many :contacts, dependent: :destroy
    has_many :identities, dependent: :destroy

    def check_contact_email(id, email)
        contacts.where.not(id: id).find_by(email: email).nil?
    end

    def self.find_for_oauth(auth)
        identity = Identity.find_for_oauth(auth)
        return identity.user if identity
        email = auth.info[:email]
        user = User.find_by(email: email)
        user = User.create(email: email, password: Devise.friendly_token[0,20]) unless user
        user.identities.create(provider: auth.provider, uid: auth.uid)
        user
    end

    def create_token
        Doorkeeper::AccessToken.where(resource_owner_id: self.id).destroy_all
        Doorkeeper::AccessToken.create(application_id: nil, resource_owner_id: self.id, scopes: 'public')
    end

    def token
        Doorkeeper::AccessToken.find_by(resource_owner_id: self.id).token
    end
end
