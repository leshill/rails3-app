Rails 3, RSpec, Factory Girl, Haml, and jQuery
==============================================

Easily generate a Rails 3 application with RSpec, Factory Girl, Haml, and
jQuery in one line:

    % rails my_app -J -T -m \
    http://github.com/leshill/rails3-app/raw/master/app.rb

rvm
---

We love `rvm`, so the application has an `.rvmrc` generated to specify a gemset.

Generators
----------

This also gives you the Factory Girl and Haml Rails 3 generators &mdash; the
generators for RSpec are in the RSpec gem &mdash; so that your factories and
views are generated using Factory Girl and Haml, and that all your generated
tests are specs. These generators are from the **rails3_generators** gem, we
pulled them out to avoid all the other dependencies included in that gem.

JavaScript Includes
-------------------

Since the Rails helper `javascript_include_tag :defaults` is looking for
Prototype, we used [this](http://flow.handle.it/past/2010/2/9/jquery_in_rails)
to add a new JavaScript expansion to pull in the jQuery libraries. Use it like
so:

    = javascript_include_tag :jquery

git
---

We love `git`, so the application has a git repo initialized with all the initial changes staged.

Wrap Up
-------

After the application has been generated, there are a few clean up commands to run:

    % cd my_app
    % gem install bundler
    % bundle install
    % bundle lock
    % script/rails generate rspec:install


Note on Patches/Pull Requests
-----------------------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don’t break it in a future version
  unintentionally.
* Commit, do not mess with rakefile, version, or history.  (if you want to have
  your own version, that is fine but bump version in a commit by itself I can
  ignore when I pull)
* Send me a pull request. Bonus points for topic branches.
