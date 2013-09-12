module SplitCat
  class GoalSubject < ActiveRecord::Base

    # Returns a hash of goal name => hypothesis name => count

    def self.subject_counts( experiment )
      counts = HashWithIndifferentAccess.new

      # Run the query

      sql = subject_count_sql( experiment )
      return counts unless result = ActiveRecord::Base.connection.execute( sql )

      # Load the results into a hash of goal id => hypothesis id => count

      result.each do |row|
        goal_id = row[ 0 ]
        hypothesis_id = row[ 1 ]
        count = row[ 2 ]

        counts[ goal_id ] ||= {}
        counts[ goal_id ][ hypothesis_id ] = count
      end

      # Translate ID keys to name symbols

      experiment.goals.each do |goal|
        unless hash = counts[ goal.name ] = counts.delete( goal.id )
          counts[ goal.name ] = HashWithIndifferentAccess.new
        else
          experiment.hypotheses.each do |h|
            hash[ h.name ] = hash.delete( h.id )
          end
        end
      end

      return counts
    end

  protected

    def self.subject_count_sql( experiment )
      sql =<<-EOSQL.strip_heredoc
        select goal_id, hypothesis_id, count( goal_id )
        from #{table_name}
        where experiment_id = #{experiment.id}
        group by goal_id, hypothesis_id
      EOSQL

      return sql
    end

  end
end
