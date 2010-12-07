rvmrc = <<-RVMRC
rvm gemset use #{app_name}
RVMRC

create_file ".rvmrc", rvmrc

gem "fabrication", ">= 0.9.4"
gem "haml-rails", ">= 0.3.4"
gem "rspec-rails", ">= 2.2.1", :group => [:development, :test]

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :fabrication, :dir => "spec/fabricators"
      g.integration_tool :rspec, :fixture => true, :views => true
    end
GENERATORS

application generators

get "http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js",  "public/javascripts/jquery.js"
get "http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.5/jquery-ui.min.js", "public/javascripts/jquery-ui.js"
`curl http://github.com/rails/jquery-ujs/raw/master/src/rails.js -o public/javascripts/rails.js`

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

DOCS

log docs
