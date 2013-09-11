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

  * Intermittent ArgumentError: A copy of SplitCat::Experiment has been removed from the module tree but is still active!
      * lib files calling static model methods?

  * Admin pages & helpers
    * Add dependent destroys
    * Archive & delete experiments
    * CSV export

  * Experiment pages & helpers
    * Cookie tagging helper

  * Save config changes (weights, descs) through to DB
  * Figure out how to protect admin pages

  * Test with large volume of test data
    * Optimize indexes

  * Cleanup
      * Configurable cookie TTL
      * Fill in all the table relationships
      * Change to hash with indifferent access

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
        * Run an experiment
        * Evaluate an experiment
        * Add user_id to subjects



