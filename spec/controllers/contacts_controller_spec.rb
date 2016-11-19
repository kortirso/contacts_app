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
end
