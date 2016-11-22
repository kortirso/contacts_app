module FeatureMacros
    def sign_in(user)
        visit root_path
        within '#login #new_user' do
            fill_in 'user_email', with: user.email
            fill_in 'user_password', with: user.password

            click_on I18n.t('buttons.login')
        end
    end
end