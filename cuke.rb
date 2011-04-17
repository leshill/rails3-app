rvm_dir = File.join([ENV['rvm_path'], 'lib'])
$LOAD_PATH.unshift(rvm_dir) unless $LOAD_PATH.include?(rvm_dir)
require 'rvm'

gem "capybara", ">= 0.4.1.1", :group => [:cucumber, :test]
gem "cucumber-rails", ">= 0.3.2", :group => [:cucumber, :test]
gem "database_cleaner", ">= 0.6.5", :group => [:cucumber, :test]
gem "factory_girl_rails", ">= 1.0.1", :group => [:cucumber, :test]
gem "factory_girl_generator", ">= 0.0.1", :group => [:cucumber, :development, :test]
gem "haml-rails", ">= 0.3.4"
gem "jquery-rails", ">= 0.2.7"
gem "launchy", ">= 0.4.0", :group => [:cucumber, :test]
gem "rspec-rails", ">= 2.5.0", :group => [:cucumber, :development, :test]
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

say_status("rvm", "use default", :green)
RVM.use! "default"

say_status "rvm", "create gemset #{app_name}", :green
RVM.rvm :gemset, :create, app_name

say_status "rvm", "use default@#{app_name}", :green
RVM.rvm :use, "default@#{app_name}", :rvmrc => true

say_status "rvm", "rvmrc trust"
RVM.rvm :rvmrc, :trust

#for some reason, multiple rvmrcs are created, torch the extras
Dir.glob('.rvmrc.*').each do |f|
  remove_file f
end

def run_rvm_cmd(cmd)
  say_status "rvm", cmd, :green
  shell_output = RVM.run(cmd)
  say_status "rvm", shell_output.stderr, :yellow if shell_output.stderr != ''
end

run_rvm_cmd('gem install bundler')
run_rvm_cmd('bundle install')
run_rvm_cmd('script/rails generate jquery:install')
run_rvm_cmd('script/rails generate rspec:install')
run_rvm_cmd('script/rails generate cucumber:install --rspec --capybara')

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

git :init
git :add => "."

say_status "done", app_name.humanize, :green
