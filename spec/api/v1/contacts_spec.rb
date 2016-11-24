describe 'Contacts API' do
    describe 'GET #index' do
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

    describe 'GET #show' do
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

                %w(id name email phone address company).each do |attr|
                    it "and contains #{attr}" do
                        expect(response.body).to be_json_eql(contact.send(attr.to_sym).to_json).at_path("contact/#{attr}")
                    end
                end

                it 'and contains modified birthday' do
                    expect(response.body).to be_json_eql(contact.birthday.strftime('%d/%m/%Y').to_json).at_path("contact/birthday")
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

    describe 'POST #create' do
        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:me) { create :user }
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            context 'with valid attributes' do
                it 'saves the new contact in the DB and it belongs to current user' do
                    expect { post '/api/v1/contacts', params: { contact: attributes_for(:contact), format: :json, access_token: access_token.token } }.to change(me.contacts, :count).by(1)
                end

                it 'and returns 200 status code' do
                    post '/api/v1/contacts', params: { contact: attributes_for(:contact), format: :json, access_token: access_token.token }

                    expect(response).to be_success
                end
                
                it 'and renders json with contact hash' do
                    post '/api/v1/contacts', params: { contact: attributes_for(:contact), format: :json, access_token: access_token.token }

                    expect(response.body).to be_json_eql(ContactSerializer.new(Contact.last).serializable_hash.to_json).at_path('contacts/0')
                end
            end

            context 'with invalid attributes' do
                it 'does not save the new contact in the DB' do
                    expect { post '/api/v1/contacts', params: { contact: attributes_for(:contact, :empty_name), format: :json, access_token: access_token.token } }.to_not change(Contact, :count)
                end

                it 'and returns 400 status code' do
                    post '/api/v1/contacts', params: { contact: attributes_for(:contact, :empty_name), format: :json, access_token: access_token.token }

                    expect(response.status).to eq 400
                end

                it 'and returns error message' do
                     post '/api/v1/contacts', params: { contact: attributes_for(:contact, :empty_name), format: :json, access_token: access_token.token }

                    expect(response.body).to eq "{\"error\":\"Incorrect contact data\"}"
                end
            end
        end

        def do_request(options = {})
            post '/api/v1/contacts', params: { format: :json }.merge(options)
        end
    end

    describe 'PATCH #update' do
        let(:me) { create :user }
        let(:access_token) { create :access_token, resource_owner_id: me.id }
        let!(:contact) { create :contact, user_id: me.id }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            context 'with valid attributes' do
                before do
                    patch "/api/v1/contacts/#{contact.id}", params: { contact: attributes_for(:contact, name: 'New Name for Contact'), format: :json, access_token: access_token.token }
                    contact.reload
                end

                it 'updates contact in the DB' do
                    expect(contact.name).to eq 'New Name for Contact'
                end

                it 'and returns 200 status code' do
                    expect(response).to be_success
                end
                
                it 'and renders json with contact hash' do
                    expect(response.body).to be_json_eql(ContactSerializer.new(contact).serializable_hash.to_json).at_path('contacts/0')
                end
            end

            context 'with invalid attributes' do
                let!(:another_contact) { create :contact }

                it 'does not update contact in the DB if incorrect data' do
                    patch "/api/v1/contacts/#{contact.id}", params: { contact: attributes_for(:contact, name: ''), format: :json, access_token: access_token.token }
                    contact.reload

                    expect(contact.name).to eq 'Contact Name'
                end

                it 'and returns 400 status code' do
                    patch "/api/v1/contacts/#{contact.id}", params: { contact: attributes_for(:contact, name: ''), format: :json, access_token: access_token.token }

                    expect(response.status).to eq 400
                end

                it 'returns error message if try access to another user contact or unexisted contact' do
                    patch "/api/v1/contacts/#{another_contact.id}", params: { contact: attributes_for(:contact), format: :json, access_token: access_token.token }

                    expect(response.body).to eq "{\"error\":\"Contact does not exist\"}"
                end

                it 'returns error message if try send incorrect data' do
                    patch "/api/v1/contacts/#{contact.id}", params: { contact: attributes_for(:contact, :empty_name), format: :json, access_token: access_token.token }

                    expect(response.body).to eq "{\"error\":\"Incorrect contact data\"}"
                end
            end
        end

        def do_request(options = {})
            patch "/api/v1/contacts/#{contact.id}", params: { contact: attributes_for(:contact), format: :json }.merge(options)
        end
    end

    describe 'DELETE #destroy' do
        let(:me) { create :user }
        let!(:contact) { create :contact, user_id: me.id }

        it_behaves_like 'API Authenticable'

        context 'authorized' do
            let(:access_token) { create :access_token, resource_owner_id: me.id }

            context 'with valid attributes' do
                it 'returns 200 status' do
                    delete "/api/v1/contacts/#{contact.id}", params: { format: :json, access_token: access_token.token }

                    expect(response).to be_success
                end

                it 'and removes contact from DB' do
                    expect { delete "/api/v1/contacts/#{contact.id}", params: { format: :json, access_token: access_token.token } }.to change(Contact, :count).by(-1)
                end
            end

            context 'with invalid attributes' do
                let!(:another_contact) { create :contact }

                it 'returns error message if try access to another user contact or unexisted contact' do
                    delete "/api/v1/contacts/#{another_contact.id}", params: { format: :json, access_token: access_token.token }

                    expect(response.body).to eq "{\"error\":\"Contact does not exist\"}"
                end
            end
        end

        def do_request(options = {})
            get "/api/v1/contacts/#{contact.id}", params: { format: :json }.merge(options)
        end
    end
end