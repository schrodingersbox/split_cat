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

    def goal_hash
       @goal_hash ||= {}.tap { |hash| goals.map { |g| hash[ g.name.to_sym ] = g } }
    end

    def hypothesis_hash
       @hypothesis_hash ||= {}.tap { |hash| hypotheses.map { |h| hash[ h.name.to_sym ] = h } }
    end

    def record_goal( goal, token )
      return true if winner_id

      return false unless goal = goal_hash[ goal.to_sym ]
      return false unless subject = Subject.find_by_token( token )

      return true unless join = HypothesisSubject.find_by_experiment_id_and_subject_id( id, subject.id )
      return true if GoalSubject.find_by_goal_id_and_subject_id( goal.id, subject.id )

      GoalSubject.create( :goal_id => goal.id, :subject_id => subject.id, :experiment_id => id, :hypothesis_id => join.hypothesis_id)

      return true
    end

    def same_structure?( experiment )
      return false if name != experiment.name
      return false if goal_hash.keys != experiment.goal_hash.keys
      return false if hypothesis_hash.keys != experiment.hypothesis_hash.keys

      return true
    end

  end
end
