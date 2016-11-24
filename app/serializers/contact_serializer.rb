class ContactSerializer < ActiveModel::Serializer
    attributes :id, :name

    class FullData < self
        attributes :email, :phone, :address, :company, :birthday

        def birthday
            object.birthday.strftime('%d/%m/%Y') if object.birthday
        end
    end
end
