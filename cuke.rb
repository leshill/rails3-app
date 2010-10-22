rvmrc = <<-RVMRC
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

gem "capybara", ">= 0.4.0", :group => [:test, :cucumber]
gem "cucumber-rails", ">= 0.3.2", :group => [:test, :cucumber]
gem "database_cleaner", ">= 0.5.2", :group => [:test, :cucumber]
gem "factory_girl_rails", ">= 1.0.0", :group => [:test, :cucumber]
gem "factory_girl_generator", ">= 0.0.1", :group => [:test, :cucumber, :development]
gem "haml-rails", ">= 0.3.4"
gem "launchy", ">= 0.3.7", :group => [:test, :cucumber]
gem "rspec-rails", ">= 2.0.1", :group => [:test, :cucumber]
gem "spork", ">= 0.8.4", :group => [:test, :cucumber]

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.intergration_tool :rspec
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
get "http://github.com/rails/jquery-ujs/raw/master/src/rails.js", "public/javascripts/rails.js"

gsub_file 'config/application.rb', 'config.action_view.javascript_expansions[:defaults] = %w()', 'config.action_view.javascript_expansions[:defaults] = %w(jquery.js jquery-ui.js rails.js)'

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

% rvm gemset create #{app_name}
% cd #{app_name}
% gem install bundler
% bundle install
% script/rails generate rspec:install
% script/rails generate cucumber:install --rspec --capybara

DOCS

log docs
