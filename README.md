# schrodingersbox/split_cat README

This engine provides a framework for split testing.

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

  * Test with large volume of test data
    * Optimize indexes


  * Modify experiment_full to include subject hypos and goals

  * Add split test probability calculator?
  * Flag for goals in funnel format and percentage along funnel, rather than of overall

  * As needed
    * Add a goals controller with action to record goal and redirect

  * Cleanup
     * Save config changes (weights, descs) through to DB
     * Archive & delete experiments
      * Fill in all the table relationships
         * Add dependent destroys
      * Fix named route problem in show.html.erb_spec.rb

  * REST API

  * Document
    * Getting started
    * Background
      * UML
      * Rules
        * A user can only have one hypothesis per-experiment
        * A user can have many goals per-experiment
    * How to
        * Create an experiment
        * Create or set a token
        * Run an experiment
        * Evaluate an experiment
        * Apply security to reports
        * Add user_id to subjects



