require 'singleton'

module SplitCat

  class Config
    include Singleton

#    attr_reader :experiments

    def initialize
      @experiments = {}
    end

    def experiment( name, description = nil )
      yield config = Experiment.new( :name => name, :description => description )
      @experiments[ name.to_sym ] = config
    end

    def experiments
      @experiments.each_pair do |key,config|
        if config.new_record?
          unless db = Experiment.includes( :goals, :hypotheses ).find_by_name( key )
            ( db = config ).save!
          end

          if db.same_structure?( config )
            @experiments[ key ] = db
          else
            @experiments.delete( key )
            raise "Experiment structure mismatch between config and db for #{name}"
          end
        end
      end

     return @experiments
    end

  end

end

