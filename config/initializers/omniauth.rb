Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '235268933224088', '1cdc768cc3c718127f7ce5ac335c52c1'
end