require_relative 'feature_helper'

RSpec.feature 'Registration management', type: :feature do
    describe 'Unauthenticated user can' do
        context 'try sign up' do
            before { visit root_path }

            it 'with all information' do
                within('#signup #new_user') do
                    fill_in 'user_email', with: 'test@gmail.com'
                    fill_in 'user_password', with: 'password'
                    fill_in 'user_password_confirmation', with: 'password'

                    click_button I18n.t('buttons.signup')
                end

                expect(page).to_not have_content I18n.t('auth.reg')
            end

            it 'without all information' do
                within('#signup #new_user') do
                    fill_in 'user_email', with: ''
                    fill_in 'user_password', with: 'password'
                    fill_in 'user_password_confirmation', with: 'password'

                    click_button I18n.t('buttons.signup')
                end

                expect(page).to have_content I18n.t('auth.reg')
            end
        end

        context 'try login' do
            let!(:user) { create :user }
            before { visit root_path }

            it 'when he registered' do
                within('#login #new_user') do
                    fill_in 'user_email', with: user.email
                    fill_in 'user_password', with: user.password

                    click_button I18n.t('buttons.login')
                end

                expect(page).to_not have_content I18n.t('auth.auth')
            end

            it 'without some information' do
                within('#login #new_user') do
                    fill_in 'user_email', with: ''
                    fill_in 'user_password', with: user.password

                    click_button I18n.t('buttons.login')
                end

                expect(page).to have_content I18n.t('auth.auth')
            end

            it 'when he not registered' do
                within('#login #new_user') do
                    fill_in 'user_email', with: 'random'
                    fill_in 'user_password', with: 'random_pass'

                    click_button I18n.t('buttons.login')
                end

                expect(page).to have_content I18n.t('auth.auth')
            end
        end
    end
end