module SplitCat
  class Experiment < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :hypotheses
    has_many :goals
    belongs_to :winner, :class_name => Hypothesis

    #############################################################################
    # simple accessors

    def add_goal( name, description = nil )
      goals << Goal.new( :name => name, :description => description )
    end

    def add_hypothesis( name, weight, description = nil )
      hypotheses << Hypothesis.new( :weight => weight, :name => name, :description => description )
    end

    # Return a memoized hash of name => goals

    def goal_hash
       @goal_hash ||= {}.tap { |hash| goals.map { |g| hash[ g.name.to_sym ] = g } }
    end

    # Return a memoized hash of name => hypotheses

    def hypothesis_hash
      @hypothesis_hash ||= {}.tap { |hash| hypotheses.map { |h| hash[ h.name.to_sym ] = h } }
    end

    # Returns a memoized sum of hypothesis weights

    def total_weight
      @total_weight ||= hypotheses.inject( 0 ) { |sum,h| sum + h.weight }
    end

    #############################################################################
    # Experiment#get_hypothesis

    # Return the winner if one has been chosen.
    # Return nil if the token can't be found.
    # Return the previously assigned hypothesis (or nil on error).
    # Choose a hypothesis randomly.
    # Record the hypothesis assignment and return it.

    def get_hypothesis( token )
      return winner if winner.present?
      return nil unless subject = Subject.find_by_token( token )

      if join = HypothesisSubject.find_by_experiment_id_and_subject_id( id, subject.id )
        hypotheses.each { |h| return h if h.id == join.hypothesis_id }
        return nil
      end

      hypothesis = choose_hypothesis
      HypothesisSubject.create( :hypothesis_id => hypothesis.id, :subject_id => subject.id, :experiment_id => id )

      return hypothesis
    end

    # Returns a random hypothesis with weighted probability

    def choose_hypothesis
      total = 0
      roll = rand( total_weight ) + 1
      hypotheses.each { |h| return h if roll <= ( total += h.weight ) }
      return hypotheses.first
    end


    #############################################################################
    # Experiment#record_goal

    # Return true immediately if a winner has already been chosen.
    # Return false if the goal or token can't be found.
    # Return true if the user isn't in the experiment or has already recorded this goal.
    # Record the goal and return true.

    def record_goal( goal, token )
      return true if winner_id

      return false unless goal = goal_hash[ goal.to_sym ]
      return false unless subject = Subject.find_by_token( token )

      return true unless join = HypothesisSubject.find_by_experiment_id_and_subject_id( id, subject.id )
      return true if GoalSubject.find_by_goal_id_and_subject_id( goal.id, subject.id )

      GoalSubject.create( :goal_id => goal.id, :subject_id => subject.id, :experiment_id => id, :hypothesis_id => join.hypothesis_id)
      return true
    end

    #############################################################################
    # Experiment#lookup

    def lookup
      return self unless new_record?

      unless db = Experiment.includes( :goals, :hypotheses ).find_by_name( name )
        ( db = self ).save!
      end

      return same_structure?( db )
    end

    # Returns true if the experiment has the same name, goals, and hypotheses as this one

    def same_structure?( experiment )
      return nil if name.to_sym != experiment.name.to_sym
      return nil if goal_hash.keys != experiment.goal_hash.keys
      return nil if hypothesis_hash.keys != experiment.hypothesis_hash.keys
      return experiment
    end

  end
end
