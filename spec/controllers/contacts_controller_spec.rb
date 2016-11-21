RSpec.describe ContactsController, type: :controller do
    describe 'GET #index' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }
            before { get :index }

            it 'collects an array of user contacts in @contacts' do
                expect(assigns(:contacts)).to match_array(contacts)
            end

            it 'and @contacts does not collect another user contact' do
                @current_user.contacts.each do |contact|
                    expect(contact).to_not eq another_contact
                end
            end

            it 'and renders main contacts page' do
                expect(response).to render_template :index
            end
        end

        def do_request(options = {})
            get :index
        end
    end

    describe 'GET #show' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }

            context 'try access his contact' do
                before { get :show, params: { id: contacts.first.id } }

                it 'collects an array of user contacts in @contacts' do
                    expect(assigns(:contacts)).to match_array(contacts)
                end

                it 'and @contacts does not collect another user contact' do
                    @current_user.contacts.each do |contact|
                        expect(contact).to_not eq another_contact
                    end
                end

                it 'and assigns the requested contact to @contact' do
                    expect(assigns(:contact)).to eq contacts.first
                end

                it 'and renders contact page' do
                    expect(response).to render_template :show
                end
            end

            it 'render 404 page if contact does not exist' do
                get :show, params: { id: 1000 }

                expect(response).to render_template 'shared/404'
            end

            it 'render 404 page if user try access another user contact' do
                get :show, params: { id: another_contact.id }

                expect(response).to render_template 'shared/404'
            end
        end

        def do_request(options = {})
            get :show, params: { id: 1 }
        end
    end

    describe 'GET #new' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }
            before { get :new }

            it 'collects an array of user contacts in @contacts' do
                expect(assigns(:contacts)).to match_array(contacts)
            end

            it 'and @contacts does not collect another user contact' do
                @current_user.contacts.each do |contact|
                    expect(contact).to_not eq another_contact
                end
            end

            it 'and assigns a new contact to @contact' do
                expect(assigns(:contact)).to be_a_new(Contact)
            end

            it 'and renders new contact page' do
                expect(response).to render_template :new
            end
        end

        def do_request(options = {})
            get :new
        end
    end

    describe 'POST #create' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            
            context 'with valid attributes' do
                it 'saves the new contact in the DB and it belongs to current user' do
                    expect { post :create, params: { contact: attributes_for(:contact) } }.to change(@current_user.contacts, :count).by(1)
                end

                it 'and redirects to main contacts page' do
                    post :create, params: { contact: attributes_for(:contact) }

                    expect(response).to redirect_to contacts_path
                end
            end

            context 'with invalid attributes, does not save the new contact in the DB' do
                let!(:old_contact) { create :contact, user: @current_user }

                it 'if name is empty' do
                    expect { post :create, params: { contact: attributes_for(:contact, :empty_name) } }.to_not change(Contact, :count)
                end

                it 'if email is empty' do
                    expect { post :create, params: { contact: attributes_for(:contact, :empty_email) } }.to_not change(Contact, :count)
                end

                it 'if user has contact with this email' do
                    expect { post :create, params: { contact: attributes_for(:contact, email: old_contact.email) } }.to_not change(Contact, :count)
                end
            end
        end

        def do_request(options = {})
            post :create, params: { contact: attributes_for(:contact) }
        end
    end

    describe 'GET #edit' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }

            context 'if try edit his own contact' do
                before { get :edit, params: { id: contacts.first.id } }

                it 'collects an array of user contacts in @contacts' do
                    expect(assigns(:contacts)).to match_array(contacts)
                end

                it 'and @contacts does not collect another user contact' do
                    @current_user.contacts.each do |contact|
                        expect(contact).to_not eq another_contact
                    end
                end

                it 'and assigns a current contact to @contact' do
                    expect(assigns(:contact)).to eq contacts.first
                end

                it 'and renders edit contact page' do
                    expect(response).to render_template :edit
                end
            end

            it 'render 404 page if contact does not exist' do
                get :edit, params: { id: 1000 }

                expect(response).to render_template 'shared/404'
            end

            it 'render 404 page if user try access another user contact' do
                get :edit, params: { id: another_contact.id }

                expect(response).to render_template 'shared/404'
            end
        end

        def do_request(options = {})
            get :edit, params: { id: 1 }
        end
    end

    describe 'PATCH #update' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }
            
            context 'if try update his own contact' do
                let(:contact) { contacts.first }

                context 'with valid attributes' do
                    before { patch :update, params: { id: contact.id, contact: { name: 'new name', email: 'new email' } } }

                    it 'updates contact in the DB' do
                        contact.reload

                        expect(contact.name).to eq 'new name'
                        expect(contact.email).to eq 'new email'
                    end

                    it 'and redirects to updated contact page' do
                        expect(response).to redirect_to contact_path(contact)
                    end
                end

                context 'with invalid attributes' do
                    let!(:old_contact) { contacts.last }

                    it 'does not update contact if name is empty' do
                        patch :update, params: { id: contact.id, contact: { name: '', email: 'new email' } }
                        contact.reload

                        expect(contact.name).to eq contact.name
                    end

                    it 'and does not update contact if email is empty' do
                        patch :update, params: { id: contact.id, contact: { name: 'new name', email: '' } }
                        contact.reload

                        expect(contact.email).to eq contact.email
                    end

                    it 'and does not update contact if user has contact with updated email' do
                        patch :update, params: { id: contact.id, contact: { name: 'new name', email: old_contact.email } }
                        contact.reload

                        expect(contact.email).to_not eq old_contact.email
                    end

                    it 'and renders edit page' do
                        patch :update, params: { id: contact.id, contact: { name: 'new name', email: old_contact.email } }

                        expect(response).to render_template :edit
                    end
                end
            end

            it 'render 404 page if contact does not exist' do
                patch :update, params: { id: 1000, contact: { name: 'new name', email: 'new email' } }

                expect(response).to render_template 'shared/404'
            end

            context 'if user try update another user contact' do
                before { patch :update, params: { id: another_contact.id, contact: { name: 'new name', email: 'new email' } } }

                it 'renders 404 page' do
                    expect(response).to render_template 'shared/404'
                end

                it 'and does not update another user contact' do
                    another_contact.reload

                    expect(another_contact.name).to_not eq 'new name'
                    expect(another_contact.email).to_not eq 'new email'
                end
            end
        end

        def do_request(options = {})
            patch :update, params: { id: 1, contact: attributes_for(:contact) }
        end
    end

    describe 'DELETE #destroy' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }

            context 'if try delete his own contact' do
                let(:contact) { contacts.first }

                it 'removes contact from DB' do
                    expect { delete :destroy, params: { id: contact.id } }.to change(Contact, :count).by(-1)
                end

                it 'and redirects to main contacts page' do
                    delete :destroy, params: { id: contact.id }

                    expect(response).to redirect_to contacts_path
                end
            end

            context 'if try delete his own contact' do
                it 'does not remove contact from DB' do
                    expect { delete :destroy, params: { id: another_contact.id } }.to_not change(Contact, :count)
                end

                it 'and render 404 page' do
                    delete :destroy, params: { id: another_contact.id }

                    expect(response).to render_template 'shared/404'
                end
            end

            it 'render 404 page if contact does not exist' do
                delete :destroy, params: { id: 1000 }

                expect(response).to render_template 'shared/404'
            end
        end

        def do_request(options = {})
            delete :destroy, params: { id: 1000 }
        end
    end
end
