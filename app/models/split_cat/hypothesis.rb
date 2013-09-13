module SplitCat
  class Hypothesis < ActiveRecord::Base
    include SplitCat::Splitable

    belongs_to :experiment, :inverse_of => :hypotheses
  end
end
