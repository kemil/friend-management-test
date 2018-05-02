Apipie.configure do |config|
  config.app_name                = "Friend Management Test"
  config.api_base_url            = "/api"
  config.doc_base_url            = ''
  config.validate                = false
  config.namespaced_resources    = true

  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"

  config.copyright               = "Friend Management 2018"
  config.default_version         = "1.0"
  config.translate               = false

end

