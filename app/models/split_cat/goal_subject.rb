module SplitCat
  class GoalSubject < ActiveRecord::Base

    # Returns a hash of goal name => hypothesis name => count

    def self.subject_counts( experiment )
      counts = {}

      sql =<<-EOSQL
        select goal_id, hypothesis_id,  count( goal_id )
        from #{table_name}
        where experiment_id = #{experiment.id}
        group by goal_id, hypothesis_id
      EOSQL

      return {} unless result = ActiveRecord::Base.connection.execute( sql )

      result.each do |row|
        goal_id = row[ 0 ]
        hypothesis_id = row[ 1 ]

        counts[ goal_id ] ||= {}
        counts[ goal_id ][ hypothesis_id ] = row[ 2 ]
      end

      # Translate ID keys to name keys

      experiment.goals.each do |g|
        if hash = counts[ g.name.to_sym ] = counts.delete( g.id )
          experiment.hypotheses.each do |h|
            hash[ h.name.to_sym ] = hash.delete( h.id )
          end
        end
      end

      return counts
    end

  end
end
