require 'split_cat/engine'
require 'split_cat/config'

module SplitCat

  def self.config
    return SplitCat::Config.instance
  end

  def self.configure
    yield config
  end

end
