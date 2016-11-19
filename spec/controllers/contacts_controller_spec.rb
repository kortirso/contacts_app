RSpec.describe ContactsController, type: :controller do
    describe 'GET #index' do
        it 'redirect to welcome page if user not login' do
            get :index

            expect(response).to render_template 'welcome/index'
        end

        context 'When user logged in' do
            sign_in_user

            it 'redirect to chats page' do
                get :index

                expect(response).to render_template :index
            end
        end
    end
end
