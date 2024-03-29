source 'https://rubygems.org'
ruby '2.2.2'

gem 'rails', '4.2.6'                                            # rails
gem 'puma'                                                      # server
gem 'active_hash'                                               # model
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'                                        # json
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'whenever', :require => false                               # cron
gem 'faraday'                                                   # http client
gem 'devise'                                                    # authentication
gem 'cancan'                                                    # authentication
gem 'rails_admin'                                               # admin
gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'    # uploader
gem 'cloudinary'                                                # image-storage
gem 'wit', '~> 4.0'                                             # wit.ai
gem 'geokit-rails'                                              # geolocation
gem 'yasuri'                                                    # scraping
gem 'trigram'                                                   # compute the similarity of two strings based on the trigram (n-gram) method
gem 'redis'
gem 'redis-activesupport'
gem 'resque'                                                    # async
gem 'rack-attack'                                               # DDoS


# front-end
gem 'sass-rails', '~> 5.0'
gem 'slim-rails'

group :development do
  gem 'web-console'
  gem 'yard'                                                    # documentation
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
  gem 'spring'
  gem 'heroku'
end

group :test do
  # test
  gem 'autodoc'
  gem 'redcarpet'
  gem 'minitest-rails-capybara'
  gem 'minitest-spec-rails'
  gem 'minitest-doc_reporter'
  gem 'minitest-stub_any_instance'
  gem 'minitest-bang'
  gem 'minitest-line'
  gem 'factory_girl_rails'
end

group :production do
  # postgresql
  gem 'pg'
  gem 'activerecord-postgresql-adapter'
end
