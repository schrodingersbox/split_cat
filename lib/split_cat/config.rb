require 'singleton'

module SplitCat

  class Config
    include Singleton

    attr_reader :experiments

    def initialize
      @experiments = {}
    end

    def experiment( name, description = nil )
      yield config = Experiment.new( :name => name, :description => description )
      (db = config).save! unless db = Experiment.find_by_name( name )

      if db.same_structure?( config )
        @experiments[ name.to_sym ] = db
      else
        raise "Experiment structure mismatch between config and db for #{name}"
      end
    end

  end

end

