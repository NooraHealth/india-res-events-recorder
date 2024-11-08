Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # this route acknowledges the ivr onboarding callbacks that we receive from Exotel
  post 'rch/update_onboarding_attempts', to: 'rch_portal/webhooks#update_ivr_onboarding_attempts'

  post 'res/update_user_attribute', to: 'ccp_res/webhooks#update_user_attribute'
  post 'res/update_user_campaign', to: 'ccp_res/webhooks#update_user_campaign'

end
