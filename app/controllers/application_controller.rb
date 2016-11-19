class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception

    private

    def get_access
        render template: 'welcome/index' unless user_signed_in?
    end

    def render_404
        render template: 'shared/404'
    end
end
