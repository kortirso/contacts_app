class Api::V1::ContactsController < Api::V1::BaseController
    before_action :find_contact, only: :show

    resource_description do
        short 'Contacts information resources'
        formats ['json']
    end

    api :GET, '/v1/contacts.json?access_token=TOKEN', 'Returns the information about all contacts of user'
    error code: 401, desc: 'Unauthorized'
    example "contacts: [{'id':8,'name':'testing'}, {'id':9,'name':'something'}]"
    def index
        data = {
            contacts: ActiveModel::Serializer::CollectionSerializer.new(current_resource_owner.contacts, each_serializer: ContactSerializer)
        }
        render json: data
    end

    api :GET, '/v1/contacts/:id.json?access_token=TOKEN', 'Returns the information about speсific contact of user'
    error code: 401, desc: 'Unauthorized'
    example "error: 'Contact does not exist'"
    example "contact: {'id':8,'name':'testing','phone':'55-55-55','address':'','company':'','birthday':''}"
    def show
        data = {
            contact: ContactSerializer::FullData.new(@contact)
        }
        render json: data
    end

    private

    def find_contact
        @contact = current_resource_owner.contacts.find_by(id: params[:id])
        render json: { error: 'Contact does not exist' } unless @contact
    end
end