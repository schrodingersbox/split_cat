require 'spec_helper'

module SplitCat
  describe HypothesisSubject do

    describe 'database' do

      it 'has columns' do
        should have_db_column( :id ).of_type( :integer )
        should have_db_column( :hypothesis_id ).of_type( :integer )
        should have_db_column( :subject_id ).of_type( :integer )
        should have_db_column( :experiment_id ).of_type( :integer )
        should have_db_column( :created_at ).of_type( :datetime )
      end

      it 'has a  compound unique index on experiment_id and subject_id' do
        should have_db_index( [ :experiment_id, :subject_id ] ).unique(true)
      end

    end

  end
end
