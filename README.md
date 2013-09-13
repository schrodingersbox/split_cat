# schrodingersbox/split_cat README

This engine provides a framework for split testing.

## Getting Started

1. Add this to your `Gemfile` and `bundle install`

		gem 'split_cat', :git => 'https://github.com/schrodingersbox/split_cat.git'

2. Add this to your `config/routes.rb`

		mount SplitCat::Engine => '/split_cat'

3. Install and run migrations

        rake split_cat:install:migrations
        rake db:migrate

4. Generate some random data

        rake split_cat:random[100,4,4]

5. Restart your Rails server

6.  Visit http://yourapp/split_cat in a browser for an HTML meter report

## Background

_TODO: ERD goes here_

### Rules

1.  Every user is represented by a unique token.
2.  Per experiment, a user may only have one hypothesis assigned.
3.  Per experiment, a use may have many goals achieved.

## How To

### Create A New Experiment

Create or add to `config/initializers/split_cat.rb`:

    SplitCat.configure do |config|

      config.experiment( :my_first_experiment, 'green vs red "buy" button' ) do |e|
        e.hypothesis( :a, 50, 'current color: green' )
        e.hypothesis( :b, 50, 'new color: red' )
        e.goal( :clicked_buy, 'user clicked the "buy" button' )
      end

      config.experiment( :my_second_experiment, 'registration flow order' ) do |e|
        # ...
      end

    end

### Implement Hypotheses

Create partials for each hypothesis.  e.g. `button_a.html.erb` and `button_b.html.erb`

When rendering the partial, scope it with the experiment:

  	render :partial => split_cat_scoped( :my_first_experiment, token, 'button' )

This will cause the partial to use the hypothesis assigned for the user/token.

### Record Goals

Call `split_cat_goal` to record a goal achieved by a user:

	split_cat_goal( :my_first_experiment, :clicked_buy, token )

### Automatically Generate Token Cookies

Add the following before_file to automatically cookie and set `@split_cat_token`:

	before_filter :set_split_cat_cookie

### Get A Token

To obtain a new token:

    @new_token = split_cat_token

To use an externally defined token:

    split_cat_token( external_token )

### Apply Security To Reports

Modify `config.application.rb` to inject your authorization filter into the controller:

    config.after_initialize do
      SplitCat::ExperimentsController.instance_eval do
        before_filter :require_login
      end
    end

## Best Practices

### Use A Constant Experiment ID

You will usually want to run a series of experiments with the same structure.
Using a constant makes it easy to 'bump' the experiment name and just update the views
and all the hypothesis selection and goal recording just keeps working.

e.g `config/initializers/split_cat.rb`

    HOMEPAGE_EXPERIMENT = :homepage_4

    SplitCat.configure do |config|

      config.experiment( :homepage_4, 'green vs red "buy" button' ) do |e|
        e.hypothesis( :a, 50, 'current color: green' )
        e.hypothesis( :b, 50, 'new color: red' )
        e.goal( :clicked_buy, 'user clicked the "buy" button' )
      end

    end

e.g. `views/home/index.html.erb`

    render :partial => split_cat_scoped( HOMEPAGE_EXPERIMENT, token, 'buy_button' )

e.g. `controllers/home_controller.rb`

    def buy
      split_cat_goal( HOMEPAGE_EXPERIMENT, :clicked_buy, token )
    end

### Set Hypothesis Using A Before Filter

Setting up the hypothesis in the controller lets you easily override it with a param,
which is nice during development, as it allows you to directly access hypothesis views without
using multiple user accounts.

  	before_filter :setup_hypothesis, :only => [ :index ]
  	
  	def setup_hypothesis
    	@hypothesis = params[ :hypothesis ]
    	@hypothesis ||= split_cat_hypothesis( HOMEPAGE_EXPERIMENT, @split_cat_token )
  	end

## Reference

 * [Getting Started with Engines](http://edgeguides.rubyonrails.org/engines.html)
 * [Testing Rails Engines With Rspec](http://whilefalse.net/2012/01/25/testing-rails-engines-rspec/)
 * [How do I write a Rails 3.1 engine controller test in rspec?](http://stackoverflow.com/questions/5200654/how-do-i-write-a-rails-3-1-engine-controller-test-in-rspec)
 * [Best practice for specifying dependencies that cannot be put in gemspec?](https://groups.google.com/forum/?fromgroups=#!topic/ruby-bundler/U7FMRAl3nJE)
 * [Clarifying the Roles of the .gemspec and Gemfile](http://yehudakatz.com/2010/12/16/clarifying-the-roles-of-the-gemspec-and-gemfile/)
 * [The Semi-Isolated Rails Engine](http://bibwild.wordpress.com/2012/05/10/the-semi-isolated-rails-engine/)
 * [FactoryGirl](https://github.com/thoughtbot/factory_girl)
 * [Shoulda](https://github.com/thoughtbot/shoulda-matchers)
 * [The one line split-test, or how to A/B all the time](http://www.startuplessonslearned.com/2008/09/one-line-split-test-or-how-to-ab-all.html)

## TODO

  * As needed
    * Add a goals controller with action to record goal and redirect
    * Add split test probability calculator
      * hypo.control - boolean flag to determine which is baseline
    * Support goals in funnel format and percentage along funnel, rather than of overall
      * goal.funnel where nil means hypo total, or reference to other goal to use as total

  * Cleanup
     * Save config changes (weights, descs) through to DB
     * Archive & delete experiments
     * Fill in all the table relationships
     * Add dependent destroys

  * REST API

  * Document
    * Background - UML
    * How to
        * Evaluate an experiment



