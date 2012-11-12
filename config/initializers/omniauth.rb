OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 'APP_ID', 'APP_SECRET', scope: "email, publish_stream"
end

