require 'split_cat/engine'
require 'split_cat/config'

module SplitCat

  def self.config
    return SplitCat::Config.instance
  end

  def self.configure
    yield config
  end

  def self.goal( name, goal, token )
    unless experiment = config.experiments[ name.to_sym ]
      Rails.logger.error( "SplitCat.goal failed to find experiment: #{name}" )
      return false
    end
    return experiment.record_goal( goal, token )
  end

  def self.hypothesis( name, token )
    unless experiment = config.experiments[ name.to_sym ]
      Rails.logger.error( "SplitCat.hypothesis failed to find experiment: #{name}" )
      return nil
    end

    h = experiment.get_hypothesis( token )
    return h ? h.name.to_sym : nil
  end

  def self.token( value = nil )
    SplitCat::Subject.create( :token => value ).token
  end

end
