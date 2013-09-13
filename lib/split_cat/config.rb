require 'singleton'

module SplitCat

  class Config
    include Singleton

    attr_reader :experiments
    attr_accessor :cookie_expiration

    def initialize
      @cookie_expiration = 10.years
      @experiments = HashWithIndifferentAccess.new
      @name = nil
    end

    def experiment( name, description = nil )
      @name =  name.to_sym
      @experiments[ @name ] = {
          :experiment => {
              :name => name,
              :description => description
          },
          :goals => [],
          :hypotheses => []
      }

      yield self
    end

    def hypothesis( name, weight, description = nil )
      @experiments[ @name ][ :hypotheses ] << { :name => name, :weight => weight, :description => description }
    end

    def goal( name, description = nil )
      @experiments[ @name ][ :goals ] << { :name => name, :description => description }
    end

    def experiment_factory( name )
      return nil unless data = @experiments[ name ]

      experiment = Experiment.new( data[ :experiment ] )
      data[ :hypotheses ].each { |h| experiment.hypotheses << Hypothesis.new( h ) }
      data[ :goals ].each { |g| experiment.goals << Goal.new( g ) }

      return experiment
    end

  end

end

