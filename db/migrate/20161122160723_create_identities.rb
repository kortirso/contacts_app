class CreateIdentities < ActiveRecord::Migration[5.0]
    def change
        create_table :identities do |t|
            t.integer :user_id
            t.string :provider
            t.string :uid
            t.timestamps
        end
        add_index :identities, :user_id
    end
end
