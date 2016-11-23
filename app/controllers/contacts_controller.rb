class ContactsController < ApplicationController
    before_action :get_access
    before_action :user_contacts
    before_action :find_contact, only: [:show, :edit, :update, :destroy]
    
    def index
        
    end

    def show

    end

    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(contacts_params.merge(user: current_user))
        if current_user.check_contact_email(nil, @contact.email) && @contact.save
            redirect_to contacts_path
        else
            render :new
        end
    end

    def edit

    end

    def update
        if current_user.check_contact_email(@contact.id, contacts_params[:email]) && @contact.update(contacts_params)
            redirect_to @contact
        else
            render :edit
        end
    end

    def destroy
        @contact.destroy
        redirect_to contacts_path
    end

    private

    def user_contacts
        @contacts = current_user.contacts.order(name: :asc)
    end

    def find_contact
        @contact = @contacts.find_by(id: params[:id])
        render_404 unless @contact
    end

    def contacts_params
        params.require(:contact).permit(:name, :email, :phone, :address, :company, :birthday)
    end
end
