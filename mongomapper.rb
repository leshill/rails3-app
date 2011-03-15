gem "bson_ext"
gem "factory_girl_rails", "1.1.beta1", :group => :test
gem "haml-rails", ">= 0.3.4"
gem "jquery-rails", ">= 0.2.7"
gem "mongo_mapper", :git => "https://github.com/jnunemaker/mongomapper.git", :branch => "rails3"
gem "mongo_ext", :group => :production
gem "rspec-rails", ">= 2.5.0", :group => [:development, :test]
gem "rails3-generators", :group => [:development, :test]

generators = <<-GENERATORS

    config.generators do |g|
      g.orm :mongo_mapper
      g.template_engine :haml
      g.test_framework :rspec, :fixture => true, :views => false
      g.integration_tool :rspec, :fixture => true, :views => true
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
% rails g jquery:install
% rails g rspec:install
% rails g mongo_mapper:config

DOCS

log docs
