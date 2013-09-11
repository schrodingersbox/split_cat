module SplitCat
  class HypothesisSubject < ActiveRecord::Base

    # Returns a hash of name => count

    def self.subject_counts( experiment )
      counts = {}

      # Run the query and load the results into a hash of hypothesis id => counts

      sql = subject_count_sql( experiment )
      return {} unless result = ActiveRecord::Base.connection.execute( sql )
      result.each { |row| counts[ row[ 0 ] ] = row[ 1 ] }

      # Translate ID keys to name keys

      experiment.hypotheses.each do |hypothesis|
        hypothesis_name = hypothesis.name.to_sym
        counts[ hypothesis_name ] = counts.delete( hypothesis.id ) || 0
     end

      return counts
    end

  protected

    def self.subject_count_sql( experiment )
      sql =<<-EOSQL.strip_heredoc
        select hypothesis_id, count( hypothesis_id )
        from #{table_name}
        where experiment_id = #{experiment.id}
        group by hypothesis_id
      EOSQL

      return sql
    end

  end
end
