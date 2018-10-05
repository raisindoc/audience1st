# Be sure to restart your server when you modify this file.

Rails.application.config.session_timeout = 10.minutes

Rails.application.config.session_store(:cookie_store,
  :key => Figaro.env.session_secret!,
  :expire_after => Rails.application.config.session_timeout)

