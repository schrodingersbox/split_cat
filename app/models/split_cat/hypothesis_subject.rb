module SplitCat
  class HypothesisSubject < ActiveRecord::Base

    # Returns a hash of name => count

    def self.subject_counts( experiment )
      counts = {}

      sql =<<-EOSQL
        select hypothesis_id, count( hypothesis_id )
        from #{table_name}
        where experiment_id = #{experiment.id}
        group by hypothesis_id
      EOSQL

      return {} unless result = ActiveRecord::Base.connection.execute( sql )
      result.each { |row| counts[ row[ 0 ] ] = row[ 1 ] }

      # Translate ID keys to name keys

      experiment.hypotheses.each do |h|
        counts[ h.name.to_sym ] = counts.delete( h.id )
      end

      return counts
    end

  end
end
