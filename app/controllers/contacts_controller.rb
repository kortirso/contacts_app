class ContactsController < ApplicationController
    before_action :get_access
    
    def index
        @contacts = current_user.contacts
    end
end
