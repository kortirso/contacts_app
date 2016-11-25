class ContactSerializer < ActiveModel::Serializer
    attributes :id, :name

    class FullData < self
        attributes :email, :phone, :address, :company, :birthday, :years

        def birthday
            object.birthday.strftime('%d/%m/%Y') if object.birthday
        end

        def years
            object.birthday ? ((Time.current - object.birthday).to_i / 31536000) : -1
        end
    end
end
