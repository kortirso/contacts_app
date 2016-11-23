class Api::V1::ContactsController < Api::V1::BaseController
    before_action :find_contact, only: [:show, :update]
    before_action :check_emails, only: [:create, :update]

    resource_description do
        short 'Contacts information resources'
        formats ['json']
    end

    api :GET, '/v1/contacts.json?access_token=TOKEN', 'Returns the information about all contacts of user'
    error code: 401, desc: 'Unauthorized'
    example "contacts: [{'id':8,'name':'testing'}, {'id':9,'name':'something'}]"
    def index
        render json: { contacts: ActiveModel::Serializer::CollectionSerializer.new(current_resource_owner.contacts, each_serializer: ContactSerializer) }
    end

    api :GET, '/v1/contacts/:id.json?access_token=TOKEN', 'Returns the information about speсific contact of user'
    error code: 401, desc: 'Unauthorized'
    example "error: 'Contact does not exist'"
    example "contact: {'id':8,'name':'testing','phone':'55-55-55','address':'','company':'','birthday':''}"
    def show
        render json: { contact: ContactSerializer::FullData.new(@contact) }
    end

    api :POST, '/v1/contacts.json', 'Creates contact'
    param :access_token, String, desc: 'Token info', required: true
    param :contact, Hash, required: true do
        param :name, String, desc: 'Name', required: true
        param :email, String, desc: 'Email', required: true
        param :phone, String, desc: 'Phone', required: true
        param :address, String, desc: 'Address', required: true
        param :company, String, desc: 'Company', required: true
        param :birthday, String, desc: 'Birthday', required: true
    end
    meta contact: { name: 'sample', email: 'sample@gmail.com', phone: '', address: '', company: '', birthday: '' }
    error code: 401, desc: 'Unauthorized'
    example "error: 'You have another contact with such email'"
    example "error: 'Incorrect contact data'"
    example "contact: {'id':8,'name':'testing','phone':'55-55-55','address':'','company':'','birthday':''}"
    def create
        contact = Contact.new(contacts_params.merge(user: current_resource_owner))
        if contact.save
            render json: { contact: ContactSerializer.new(contact) }
        else
            render json: { error: 'Incorrect contact data' }
        end
    end

    api :PATCH, '/v1/contacts/:id.json', 'Updates contact'
    param :access_token, String, desc: 'Token info', required: true
    param :contact, Hash, required: true do
        param :name, String, desc: 'Name', required: true
        param :email, String, desc: 'Email', required: true
        param :phone, String, desc: 'Phone', required: true
        param :address, String, desc: 'Address', required: true
        param :company, String, desc: 'Company', required: true
        param :birthday, String, desc: 'Birthday', required: true
    end
    meta contact: { name: 'sample', email: 'sample@gmail.com', phone: '', address: '', company: '', birthday: '' }
    error code: 401, desc: 'Unauthorized'
    example "error: 'You have another contact with such email'"
    example "error: 'Incorrect contact data'"
    example "contact: {'id':8,'name':'testing','phone':'55-55-55','address':'','company':'','birthday':''}"
    def update
        if @contact.update(contacts_params)
            render json: { contact: ContactSerializer.new(@contact) }
        else
            render json: { error: 'Incorrect contact data' }
        end
    end

    private

    def find_contact
        @contact = current_resource_owner.contacts.find_by(id: params[:id])
        render json: { error: 'Contact does not exist' } unless @contact
    end

    def check_emails
        unless current_resource_owner.check_contact_email(@contact.nil? ? nil : @contact.id, contacts_params[:email])
            render json: { error: 'You have another contact with such email' }
        end
    end

    def contacts_params
        params.require(:contact).permit(:name, :email, :phone, :address, :company, :birthday)
    end
end