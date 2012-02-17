# Generate a default user with valid characteristics
#
# Author:: Melissa Winstanley
FactoryGirl.define do
  factory :user do
    first_name   'Melissa'
    last_name    'Winstanley'
    username     'mwinst'
    facebook_id  619716339
  end
end