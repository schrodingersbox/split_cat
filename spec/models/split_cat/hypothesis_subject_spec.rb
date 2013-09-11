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

      it 'has indexes' do
        should have_db_index( [ :experiment_id, :subject_id ] ).unique(true)
       end

    end

    describe '#subject_counts' do

      it 'returns a hash of hypothesis name => count' do
        experiment = FactoryGirl.create( :experiment_full )
        subject = FactoryGirl.create( :subject_a )
        hypothesis = experiment.hypotheses.first

        HypothesisSubject.create(
            :hypothesis_id => hypothesis.id,
            :subject_id => subject.id,
            :experiment_id => experiment.id )

        counts = HypothesisSubject.subject_counts( experiment )
        counts.should be_an_instance_of( Hash )
        counts[ hypothesis.name.to_sym ].should eql( 1 )
      end

    end

  end
end
