class AddBirthdayToContacts < ActiveRecord::Migration[5.0]
    def change
        add_column :contacts, :birthday, :datetime
    end
end
