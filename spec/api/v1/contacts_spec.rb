describe 'Contacts API' do
    describe 'GET /index' do
        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let!(:contact) { create :contact, user_id: me.id }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            before { get '/api/v1/contacts', params: { format: :json, access_token: access_token.token } }

            it 'returns 200 status' do
                expect(response).to be_success
            end

            it 'contains list of user contacts' do
                expect(response.body).to be_json_eql(ContactSerializer.new(contact).serializable_hash.to_json).at_path('contacts/0')
            end
        end

        def do_request(options = {})
            get '/api/v1/contacts', params: { format: :json }.merge(options)
        end
    end

    describe 'GET /show' do
        let(:me) { create :user }
        let!(:contact) { create :contact, user_id: me.id }
        let!(:another_contact) { create :contact }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            context 'with valid attributes' do
                before { get "/api/v1/contacts/#{contact.id}", params: { format: :json, access_token: access_token.token } }

                it 'returns 200 status' do
                    expect(response).to be_success
                end

                %w(id name email phone address company birthday).each do |attr|
                    it "contains #{attr}" do
                        expect(response.body).to be_json_eql(contact.send(attr.to_sym).to_json).at_path("contact/#{attr}")
                    end
                end
            end

            context 'with invalid attributes' do
                it 'returns error message if try access to another user contact or unexisted contact' do
                    get "/api/v1/contacts/#{another_contact.id}", params: { format: :json, access_token: access_token.token }

                    expect(response.body).to eq "{\"error\":\"Contact does not exist\"}"
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/contacts/#{contact.id}", params: { format: :json }.merge(options)
        end
    end
end