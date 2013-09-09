module SplitCat
  class Experiment < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :hypotheses
    has_many :goals

  end
end
