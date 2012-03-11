bundle install
rake environment RAILS_ENV=test db:migrate
bundle exec rspec spec/
