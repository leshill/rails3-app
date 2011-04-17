rvm_dir = File.join([ENV['rvm_path'], 'lib'])
$LOAD_PATH.unshift(rvm_dir) unless $LOAD_PATH.include?(rvm_dir)
require 'rvm'

gem "fabrication", ">= 0.9.5"
gem "haml-rails", ">= 0.3.4"
gem "jquery-rails", ">= 0.2.7"
gem "rspec-rails", ">= 2.5.0", :group => [:development, :test]

generators = <<-GENERATORS

    config.generators do |g|
      g.test_framework :rspec, :fixture => true, :views => false
      g.fixture_replacement :fabrication, :dir => "spec/fabricators"
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

say_status("rvm", "use default", :green)
RVM.use! "default"

say_status "rvm", "create gemset #{app_name}", :green
RVM.rvm :gemset, :create, app_name

say_status "rvm", "use default@#{app_name}", :green
RVM.rvm :use, "default@#{app_name}", :rvmrc => true

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

create_file "log/.gitkeep"
create_file "tmp/.gitkeep"

git :init
git :add => "."

say_status "done", app_name.humanize, :green
