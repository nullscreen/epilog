# frozen_string_literal: true

source 'https://rubygems.org'
gemspec

group :test do
  gem 'rails', "~> #{ENV.fetch('RAILS_VERSION', '5.2')}"
  if ENV.fetch('RAILS_VERSION', '5.2').to_f >= 5
    gem 'sqlite3', '~> 1.4'
  else
    gem 'sqlite3', '= 1.3.10' # rubocop:disable Bundler/DuplicatedGem
  end
end
