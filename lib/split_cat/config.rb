require 'singleton'

module SplitCat

  class Config
    include Singleton

    def initialize
      @experiments = {}
    end

    def experiment( name, description = nil )
      begin
        yield config = Experiment.new( :name => name, :description => description )
        @experiments[ name.to_sym ] = config
      rescue Exception => e
        Rails.logger.error( "SplitCat.Config.experiment failed to create #{name}:" + e.to_s  )
      end
    end

    def experiments
      @experiments.each_pair do|key,experiment|
        @experiments[ key ] = experiment.lookup if experiment && experiment.new_record?
      end
      return @experiments
    end

  end

end

