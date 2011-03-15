gem "capybara", ">= 0.4.0", :group => [:cucumber, :test]
gem "cucumber-rails", ">= 0.3.2", :group => [:cucumber, :test]
gem "database_cleaner", ">= 0.5.2", :group => [:cucumber, :test]
gem "factory_girl_rails", ">= 1.0.0", :group => [:cucumber, :test]
gem "factory_girl_generator", ">= 0.0.1", :group => [:cucumber, :development, :test]
gem "haml-rails", ">= 0.3.4"
gem "jquery-rails", ">= 0.2.7"
gem "launchy", ">= 0.3.7", :group => [:cucumber, :test]
gem "rspec-rails", ">= 2.2.1", :group => [:cucumber, :development, :test]
gem "spork", ">= 0.8.4", :group => [:cucumber, :test]

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.integration_tool :rspec
    end
GENERATORS

application generators

gsub_file 'config/application.rb', 'config.filter_parameters += [:password]', 'config.filter_parameters += [:password, :password_confirmation]'

layout = <<-LAYOUT
!!!
%html
  %head
    %title #{app_name.humanize}
    = stylesheet_link_tag :all
    = javascript_include_tag :defaults
    = csrf_meta_tag
  %body
    = yield
LAYOUT

remove_file "app/views/layouts/application.html.erb"
create_file "app/views/layouts/application.html.haml", layout

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

git :init
git :add => "."

docs = <<-DOCS

Run the following commands to complete the setup of #{app_name.humanize}:

% cd #{app_name}
% rvm use --create --rvmrc default@#{app_name}
% gem install bundler
% bundle install
% script/rails generate jquery:install
% script/rails generate rspec:install
% script/rails generate cucumber:install --rspec --capybara

DOCS

log docs
