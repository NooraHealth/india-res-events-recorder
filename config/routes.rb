# == Route Map
#
#                                       Prefix Verb   URI Pattern                                                                                       Controller#Action
#               rch_update_onboarding_attempts POST   /rch/update_onboarding_attempts(.:format)                                                         rch_portal/webhooks#update_ivr_onboarding_attempts
#                    res_update_user_attribute POST   /res/update_user_attribute(.:format)                                                              ccp_res/webhooks#update_user_attribute
#                     res_update_user_campaign POST   /res/update_user_campaign(.:format)                                                               ccp_res/webhooks#update_user_campaign
#            res_high_risk_pregnancy_hrp_alert POST   /res/high_risk_pregnancy/hrp/alert(.:format)                                                      alerts/alerts#create
#         res_high_risk_pregnancy_patient_list GET    /res/high_risk_pregnancy/patient/list(.:format)                                                   alerts/alerts#hcw_active_alerts
#      res_high_risk_pregnancy_patient_details GET    /res/high_risk_pregnancy/patient/details(.:format)                                                alerts/hcw_list_alerted_users#hcw_list_alerted_users
#                res_health_alert_patient_list GET    /res/health-alert/patient/list(.:format)                                                          alerts/alerts#hcw_active_alerts
#             res_health_alert_patient_details GET    /res/health-alert/patient/details(.:format)                                                       alerts/alerts#patient_details
# res_high_risk_pregnancy_patient_confirm_care POST   /res/high_risk_pregnancy/patient/confirm-care(.:format)                                           alerts/alerts#patient_confirm_care
#     res_high_risk_pregnancy_hcw_confirm_care POST   /res/high_risk_pregnancy/hcw/confirm-care(.:format)                                               alerts/alerts#hcw_confirm_care
#                rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#                   rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#                rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#          rails_mandrill_inbound_health_check GET    /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#                rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#                 rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#               rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                              POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#                rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#                                              PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                              PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#update
#                                              DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#destroy
#     new_rails_conductor_inbound_email_source GET    /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#        rails_conductor_inbound_email_sources POST   /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#        rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
#     rails_conductor_inbound_email_incinerate POST   /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                           rails_service_blob GET    /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                     rails_service_blob_proxy GET    /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                              GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                    rails_blob_representation GET    /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#              rails_blob_representation_proxy GET    /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                              GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                           rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                    update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                         rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create

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
  get 'res/high_risk_pregnancy/patient/details/', to: 'alerts/alerts#patient_details'

  post 'res/high_risk_pregnancy/patient/confirm-care/', to: 'alerts/alerts#patient_confirm_care'

  post 'res/high_risk_pregnancy/hcw/confirm-care/', to: 'alerts/alerts#hcw_confirm_care'

  ############## HRP ENDPOINTS ##############

  ############## Alert endpoints ############
  post 'res/health-alert/new/', to: 'alerts/alerts#create'
  get 'res/health-alert/patient/list/', to: 'alerts/alerts#hcw_active_alerts'
  get 'res/health-alert/patient/details/', to: 'alerts/alerts#patient_details'
  post 'res/health-alert/patient/confirm-care/', to: 'alerts/alerts#patient_confirm_care'
  post 'res/health-alert/hcw/patient/confirm-care/', to: 'alerts/alerts#hcw_confirm_care'
  ############## Alert endpoints ############

end
