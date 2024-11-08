Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # this route acknowledges the ivr onboarding callbacks that we receive from Exotel
  post 'rch/update_onboarding_attempts', to: 'rch_portal/webhooks#update_ivr_onboarding_attempts'

  post 'res/update_user_attribute', to: 'ccp_res/webhooks#update_user_attribute'
  post 'res/update_user_campaign', to: 'ccp_res/webhooks#update_user_campaign'


  ############## HRP ENDPOINTS ##############

  post 'res/high_risk_pregnancy/hrp/alert', to: 'alerts/alerts#create'

  get 'res/high_risk_pregnancy/patient/list/', to: 'alerts/alerts#hcw_active_alerts'
  get 'res/high_risk_pregnancy/patient/details/', to: 'alerts/hcw_list_alerted_users#hcw_list_alerted_users'

  post 'res/high_risk_pregnancy/hcw/patient/confirm-care/', to: 'alerts/alerts#hcw_confirm_care'

  # post 'res/high_risk_pregnancy/hcw/patient/deny-care/', to: 'alerts/hcw_patient_care#deny'

  post 'res/high_risk_pregnancy/patient/confirm-care/', to: 'alerts/alerts#patient_confirm_care'
  # post 'res/high_risk_pregnancy/patient/deny-care/', to: 'alerts/patient_care#deny'

  ############## HRP ENDPOINTS ##############

end
