module SplitCat
  class Goal < ActiveRecord::Base
    include SplitCat::Splitable

    belongs_to :experiment, :inverse_of => :goals
  end
end
