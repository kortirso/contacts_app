class ContactsController < ApplicationController
    before_action :get_access
    before_action :user_contacts, except: :create
    
    def index
        
    end

    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(contacts_params.merge(user: current_user))
        if current_user.check_contact_email(@contact.email) && @contact.save
            redirect_to contacts_path
        else
            render :new
        end
    end

    private

    def user_contacts
        @contacts = current_user.contacts.order(name: :asc)
    end

    def contacts_params
        params.require(:contact).permit(:name, :email, :phone, :address, :company)
    end
end
