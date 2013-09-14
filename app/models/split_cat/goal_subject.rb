module SplitCat
  class GoalSubject < ActiveRecord::Base

    # Returns a hash of goal name => hypothesis name => count

    def self.subject_counts( experiment )
      counts = HashWithIndifferentAccess.new

      # Run the query

      sql = subject_count_sql( experiment )
      ActiveRecord::Base.connection.execute( sql ).each do |row|
        subject_count_row( counts, row )
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
        select goal_id, hypothesis_id, count( goal_id ) as subject_count
        from #{table_name}
        where experiment_id = #{experiment.id}
        group by goal_id, hypothesis_id
      EOSQL

      return sql
    end

    def self.subject_count_row( counts, row )
      if row.is_a?( Hash )
        goal_id = row[ 'goal_id' ].to_i
        hypothesis_id = row[ 'hypothesis_id' ].to_i
        count = row[ 'subject_count' ].to_i
      else
        goal_id = row[ 0 ].to_i
        hypothesis_id = row[ 1 ].to_i
        count = row[ 2 ].to_i
      end

      counts[ goal_id ] ||= {}
      counts[ goal_id ][ hypothesis_id ] = count
    end

  end
end
