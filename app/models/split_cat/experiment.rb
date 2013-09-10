module SplitCat
  class Experiment < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :hypotheses
    has_many :goals

    def add_goal( name, description = nil )
      goals << Goal.new( :name => name, :description => description )
    end

    def add_hypothesis( name, weight, description = nil )
      hypotheses << Hypothesis.new( :weight => weight, :name => name, :description => description )
    end

    def goal_names
      goals.map { |goal| goal.name }
    end

    def hypothesis_names
      hypotheses.map { |hypothesis| hypothesis.name }
    end

    def same_structure?( experiment )
      return false if name != experiment.name
      return false if goal_names != experiment.goal_names
      return false if hypothesis_names != experiment.hypothesis_names

      return true
    end

  end
end
