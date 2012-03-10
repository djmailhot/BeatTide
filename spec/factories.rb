# Factories for generating valid model objects
# Authors:: David Mailhot, Melissa Winstanley
#
# Included factories:
#   user
#   song
#   album
#   artist
#   post
FactoryGirl.define do

  # Generate a user with a unique username and facebook id
  # with each call to the factory
  factory :user do
    first_name   'Melissa'
    last_name    'Winstanley'
    sequence(:username)     { |n| "mwinst#{n}" }
    sequence(:facebook_id)  { |n| 619716339 + n }
  end

  # Generate a song with a unique api id
  # with each call to the factory
  factory :song do
    sequence(:api_id)  { |n| 42 + n }
    title              "I Want You Now"
  end

  # Generate an album with a unique api id
  # with each call to the factory
  factory :album do
    sequence(:api_id) { |n| 42 + n }
    title             "You Are Beautiful"
  end

  # Generate an artist with a unique api id
  # with each call to the factory
  factory :artist do
    sequence(:api_id) { |n| 42 + n }
    title             "MegaBeats"
  end

  # Generate a post, with song and user attributes parameterized
  factory :post do
    song
    user
  end
end
