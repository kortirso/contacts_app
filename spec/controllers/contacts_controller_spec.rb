RSpec.describe ContactsController, type: :controller do
    describe 'GET #index' do
        it 'redirect to welcome page if user not login' do
            get :index

            expect(response).to render_template 'welcome/index'
        end

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
    end

    describe 'GET #show' do
        it 'redirect to welcome page if user not login' do
            get :show, params: { id: 1 }

            expect(response).to render_template 'welcome/index'
        end

        context 'When user logged in' do
            sign_in_user
            let!(:contacts) { create_list(:contact, 2, user: @current_user) }
            let!(:another_contact) { create :contact }

            context 'try access his contact' do
                context 'if contact is exist' do
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
            end

            it 'render 404 page if user try access another user contact' do
                get :show, params: { id: another_contact.id }

                expect(response).to render_template 'shared/404'
            end
        end
    end

    describe 'GET #new' do
        it 'redirect to welcome page if user not login' do
            get :index

            expect(response).to render_template 'welcome/index'
        end

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
    end

    describe 'POST #create' do
        it 'redirect to welcome page if user not login' do
            post :create, params: { contact: attributes_for(:contact) }

            expect(response).to render_template 'welcome/index'
        end

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

            context 'with invalid attributes' do
                let!(:old_contact) { create :contact, user: @current_user }

                it 'does not save the new contact in the DB if name is empty' do
                    expect { post :create, params: { contact: attributes_for(:contact, :empty_name) } }.to_not change(Contact, :count)
                end

                it 'does not save the new contact in the DB if email is empty' do
                    expect { post :create, params: { contact: attributes_for(:contact, :empty_email) } }.to_not change(Contact, :count)
                end

                it 'does not save the new contact in the DB if user has contact with this email' do
                    expect { post :create, params: { contact: attributes_for(:contact, email: old_contact.email) } }.to_not change(Contact, :count)
                end
            end
        end
    end
end
