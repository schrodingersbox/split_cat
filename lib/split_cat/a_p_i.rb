module SplitCat
  module API

    def split_cat_token( value = nil )
      SplitCat::Subject.create( :token => value ).token
    end

    def split_cat_goal( name, goal, token )
      unless experiment = split_cat_factory( name )
        Rails.logger.error( "Experiment.goal failed to find experiment: #{name}" )
        return false
      end

      return experiment.record_goal( goal, token )
    end

    def split_cat_hypothesis( name, token )
      unless experiment = split_cat_factory( name )
        Rails.logger.error( "Experiment.hypothesis failed to find experiment: #{name}" )
        return nil
      end

      h = experiment.get_hypothesis( token )
      return h ? h.name.to_sym : nil
    end

    def split_cat_factory( name )
      unless template = SplitCat.config.experiment_factory( name )
        Rails.logger.error( "Experiment.factory not configured for experiment: #{name}" )
        return nil
      end

      if experiment = Experiment.includes( :goals, :hypotheses ).find_by_name( name )
        unless experiment.same_structure?( template )
          experiment = nil
          Rails.logger.error( "Experiment.factory mismatched experiment: #{name}" )
        end
      else
        if template.save
          experiment = template
        else
          Rails.logger.error( "Experiment.factory failed to save experiment: #{name}" )
        end
      end

      return experiment
    end

  end
end