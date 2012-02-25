# Initializes the Facebook authentication keys for each development
# environment, allowing user login and signup with Facebook credentials.
# 
# Author:: Melissa Winstanley

Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env.production?
    provider :facebook, '228087167287078', 'd65b5e113f1d7bb45877467fbfaa8357'
  elsif Rails.env.development?
    provider :facebook, '323366737699173', '708bec06393c1ad2c5c48d81c1a2ae09'
  else
    provider :facebook, '323366737699173', '708bec06393c1ad2c5c48d81c1a2ae09'
  end
end