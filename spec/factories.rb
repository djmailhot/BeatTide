# Factories for generating valid model objects
#
# Included factories:
#   user
#   song
#   post
#
FactoryGirl.define do

  # Generate a default user with valid characteristics
  factory :user do
    first_name   'Melissa'
    last_name    'Winstanley'
    username     'mwinst'
    facebook_id  619716339
  end

  factory :song do
    api_id 42
    title "The Last of the Wilds"
  end

  factory :post do
    song 
    user
  end
end
