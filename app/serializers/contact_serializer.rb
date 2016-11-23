class ContactSerializer < ActiveModel::Serializer
    attributes :id, :name

    class FullData < self
        attributes :email, :phone, :address, :company, :birthday
    end
end
