class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private

    def get_access
        render template: 'welcome/index' unless user_signed_in?
    end
end
