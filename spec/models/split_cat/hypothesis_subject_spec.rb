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

    #############################################################################
    # HypothesisSubject::subject_counts

    describe '::subject_counts' do

      let( :experiment ) { FactoryGirl.create( :experiment_full ) }
      let( :subject )    { FactoryGirl.create( :subject_a ) }

      it 'returns a hash of hypothesis name => count' do
        hypothesis = experiment.hypotheses.first

        HypothesisSubject.create(
            :hypothesis_id => hypothesis.id,
            :subject_id => subject.id,
            :experiment_id => experiment.id )

        counts = HypothesisSubject.subject_counts( experiment )
        counts.should be_an_instance_of( Hash )
        counts[ hypothesis.name.to_sym ].should eql( 1 )
      end

      it 'includes hypotheses with no subjects in db' do
        counts = HypothesisSubject.subject_counts( experiment )

        counts.size.should eql( experiment.hypotheses.size )
        experiment.hypotheses.each do |hypothesis|
          counts[ hypothesis.name.to_sym ].should eql( 0 )
        end
      end

    end

    #############################################################################
    # HypothesisSubject::subject_count_sql

    describe '::subject_count_sql' do

      let( :experiment ) { FactoryGirl.create( :experiment_full ) }

      it 'generates SQL given an experiment' do
        HypothesisSubject.send( :subject_count_sql, experiment ).should eql_file( 'spec/data/hypothesis_subject_count_sql.sql' )
      end
    end


  end
end
