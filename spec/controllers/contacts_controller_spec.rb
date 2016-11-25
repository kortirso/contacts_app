RSpec.describe ContactsController, type: :controller do
    describe 'GET #index' do
        it_behaves_like 'Unauthorized'

        context 'When user logged in' do
            sign_in_user

            it 'renders main contacts page' do
                get :index

                expect(response).to render_template :index
            end
        end

        def do_request(options = {})
            get :index
        end
    end
end
