# Initializes the Facebook authentication keys for each development
# environment, allowing user login and signup with Facebook credentials.
# 
# Author:: Melissa Winstanley

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, '235268933224088', '1cdc768cc3c718127f7ce5ac335c52c1'
  elsif Rails.env.development?
    provider :facebook, '323366737699173', '708bec06393c1ad2c5c48d81c1a2ae09'
  else
    provider :facebook, '323366737699173', '708bec06393c1ad2c5c48d81c1a2ae09'
  end
end
