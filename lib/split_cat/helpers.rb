module SplitCat
  module Helpers

    #############################################################################
    # #split_cat_token

    def split_cat_token( value = nil )
      SplitCat::Subject.create( :token => value ).token
    end

    #############################################################################
    # #split_cat_goal

    def split_cat_goal( name, goal, token )
      unless experiment = Experiment.factory( name )
        Rails.logger.error( "Experiment.goal failed to find experiment: #{name}" )
        return false
      end

      return experiment.record_goal( goal, token )
    end

    #############################################################################
    # #split_cat_hypothesis

    def split_cat_hypothesis( name, token )
      unless experiment = Experiment.factory( name )
        Rails.logger.error( "Experiment.hypothesis failed to find experiment: #{name}" )
        return nil
      end

      h = experiment.get_hypothesis( token )
      return h ? h.name.to_sym : nil
    end

    #############################################################################
    # #split_cat_scope

    def split_cat_scope( root, name, token, hypothesis = nil )
      hypothesis = split_cat_hypothesis( name, token ) unless hypothesis
      return root + '_' + hypothesis.to_s
    end

    #############################################################################
    # #set_split_cat_cookie

    def set_split_cat_cookie( options = {} )
     if options[ :force ] || !cookies[ :split_cat_token ]
       expires = SplitCat.config.cookie_expiration.from_now
       cookies[ :split_cat_token ] = { :value => split_cat_token, :expires => expires }
     end

     @split_cat_token = cookies[ :split_cat_token ]
    end

  end
end