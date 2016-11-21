shared_examples_for 'Unauthorized' do
    context 'if user unauthorized' do
        it 'redirects to welcome page' do
            do_request

            expect(response).to render_template 'welcome/index'
        end
    end
end