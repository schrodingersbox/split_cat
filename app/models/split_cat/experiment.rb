require 'csv'

module SplitCat

  class Experiment < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :hypotheses, -> { order( :name ) }, :inverse_of => :experiment
    has_many :goals, -> { order( :name ) }, :inverse_of => :experiment

    belongs_to :winner, :class_name => Hypothesis

    # Returns a memoized array of goal name => hypothesis_name => subject counts

    def goal_counts
      @goal_counts ||= GoalSubject.subject_counts( self )
    end

    # Return a memoized hash of goal name => goals

    def goal_hash
      return @goal_hash ||= hash_name_to_item( goals )
     end

    def hash_name_to_item( items )
      hash = HashWithIndifferentAccess.new
      items.map { |i| hash[ i.name ] = i }
      return hash
    end

    # Returns a memoized array of hypothesis name => subject counts

    def hypothesis_counts
      @hypothesis_counts ||= HypothesisSubject.subject_counts( self )
    end

    # Return a memoized hash of hypothesis name => hypotheses

    def hypothesis_hash
      return @hypothesis_hash ||= hash_name_to_item( hypotheses )
    end

    def total_subjects
      @total_subjects ||= hypothesis_counts.values.inject( 0 ) { |sum,count| sum + ( count || 0 ) }
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
      roll = Kernel.rand( total_weight ) + 1
      hypothesis = nil
      hypotheses.each do |h|
        if roll <= ( total += h.weight )
          hypothesis ||= h
        end
      end
      hypothesis ||= hypotheses.first
      return hypothesis
    end

    #############################################################################
    # Experiment#record_goal

    # Return true immediately if a winner has already been chosen.
    # Return false if the goal or token can't be found.
    # Return true if the user isn't in the experiment or has already recorded this goal.
    # Record the goal and return true.

    def record_goal( goal, token )
      return true if winner_id

      return false unless goal = goal_hash[ goal ]
      return false unless subject = Subject.find_by_token( token )

      return true unless join = HypothesisSubject.find_by_experiment_id_and_subject_id( id, subject.id )
      return true if GoalSubject.find_by_goal_id_and_subject_id( goal.id, subject.id )

      GoalSubject.create( :goal_id => goal.id, :subject_id => subject.id, :experiment_id => id, :hypothesis_id => join.hypothesis_id)
      return true
    end

    # Returns true if the experiment has the same name, goals, and hypotheses as this one

    def same_structure?( experiment )
      return nil if name.to_sym != experiment.name.to_sym
      return nil if goal_hash.keys != experiment.goal_hash.keys
      return nil if hypothesis_hash.keys != experiment.hypothesis_hash.keys
      return experiment
    end

    #############################################################################
    # Experiment#to_csv

    # Generates a CSV representing the experiment results
    #  * header row of hypothesis names
    #  * row of total subject count per hypothesis
    #  * goal rows of subject count per hypothesis

    def to_csv
      CSV.generate do |csv|
        hypothesis_names = hypotheses.map { |h| h.name }
        hypothesis_totals = hypotheses.map { |h| hypothesis_counts[ h.name ] || 0 }

        csv << [ nil ] + hypothesis_names
        csv << [ 'total' ] + hypothesis_totals

        goals.each do |g|
          goal_totals = hypotheses.map { |h| goal_counts[ g.name ][ h.name ] || 0 }
          csv << [ g.name ] + goal_totals
        end
      end
    end

    #############################################################################
    # Experiment#factory

    cattr_reader :cache
    @@cache = HashWithIndifferentAccess.new

    def self.factory( name )
      if experiment = @@cache[ name ]
        return experiment
      end

      template = SplitCat.config.template( name )
      if experiment = Experiment.includes( :goals, :hypotheses ).find_by_name( name )
        return nil if template && !experiment.same_structure?( template )
      else
        experiment = template if template && template.save
      end

      @@cache[ name.to_sym ] = experiment

      return experiment
    end

  end
end
