Rails.application.routes.draw do
    apipie
    use_doorkeeper
    devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

    resources :contacts, only: :index

    namespace :api do
        namespace :v1 do
            resource :profiles do
                get :me, on: :collection
            end
            resources :contacts, except: [:new, :edit]
        end
    end

    root 'contacts#index'
end
