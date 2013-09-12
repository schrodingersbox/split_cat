require 'split_cat/engine'
require 'split_cat/config'
require 'split_cat/a_p_i'

include SplitCat::API

module SplitCat

  def self.config
    return SplitCat::Config.instance
  end

  def self.configure
    yield config
  end

end
