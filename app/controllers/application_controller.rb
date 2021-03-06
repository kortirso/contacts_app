class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :set_locale

    private

    def get_access
        render template: 'welcome/index' unless user_signed_in?
    end

    def set_locale
        session[:locale] == 'ru' || session[:locale] == 'en' ? I18n.locale = session[:locale] : I18n.locale = http_accept_language.compatible_language_from(I18n.available_locales)
    end

    def after_sign_in_path_for(resource)
        current_user.create_token
        root_path
    end
end
