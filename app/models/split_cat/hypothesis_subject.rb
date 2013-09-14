module SplitCat
  class HypothesisSubject < ActiveRecord::Base

    # Returns a hash of name => count

    def self.subject_counts( experiment )
      counts = HashWithIndifferentAccess.new

      # Run the query and load the results into a hash of hypothesis id => counts

      sql = subject_count_sql( experiment )
      ActiveRecord::Base.connection.execute( sql ).each do |row|
        subject_count_row( counts, row )
      end

      # Translate ID keys to name keys

      experiment.hypotheses.each do |hypothesis|
        counts[ hypothesis.name.to_sym ] = counts.delete( hypothesis.id ) || 0
     end

      return counts
    end

  protected

    def self.subject_count_sql( experiment )
      sql =<<-EOSQL.strip_heredoc
        select hypothesis_id, count( hypothesis_id ) as subject_count
        from #{table_name}
        where experiment_id = #{experiment.id}
        group by hypothesis_id
      EOSQL

      return sql
    end

    def self.subject_count_row( counts, row )
      if row.is_a?( Hash )
        id = row[ 'hypothesis_id' ].to_i
        count = row[ 'subject_count' ].to_i
      else
        id = row[ 0 ].to_i
        count = row[ 1 ].to_i
      end

      counts[ id ] = count
    end

  end
end
