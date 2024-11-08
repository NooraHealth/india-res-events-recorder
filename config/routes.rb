Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # this route acknowledges the ivr onboarding callbacks that we receive from Exotel
  post 'rch/update_onboarding_attempts', to: 'rch_portal/webhooks#update_ivr_onboarding_attempts'

  post 'res/update_user_attribute', to: 'ccp_res/webhooks#update_user_attribute'
  post 'res/update_user_campaign', to: 'ccp_res/webhooks#update_user_campaign'

  post 'res/health-alert/new/', to: 'alerts/create_alert#create_alert'

  get 'res/health-alert/patient/list/', to: 'alerts/hcw_list_alerted_users#hcw_list_alerted_users'
  get 'res/health-alert/patient/details/', to: 'alerts/patient_details#patient_details'

  post 'res/health-alert/hcw/patient/confirm-care/', to: 'alerts/hcw_patient_care#confirm'
  post 'res/health-alert/hcw/patient/deny-care/', to: 'alerts/hcw_patient_care#deny'

  post 'res/health-alert/patient/confirm-care/', to: 'alerts/patient_care#confirm'
  post 'res/health-alert/patient/deny-care/', to: 'alerts/patient_care#deny'

end
