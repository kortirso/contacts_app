Rails.application.routes.draw do
    use_doorkeeper
    devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

    resources :contacts

    namespace :api do
        namespace :v1 do
            resource :profiles do
                get :me, on: :collection
            end
            resources :contacts
        end
    end

    root 'contacts#index'
end
