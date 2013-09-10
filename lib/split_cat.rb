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
    return false unless experiment = config.experiments[ name.to_sym ]
    return experiment.record_goal( goal, token )
  end

  def self.hypothesis( name, token )
    return nil unless experiment = config.experiments[ name.to_sym ]
    return experiment.get_hypothesis( token )
  end

  def self.token
    SplitCat::Subject.create.token
  end

end
