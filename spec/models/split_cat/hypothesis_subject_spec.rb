require 'spec_helper'

module SplitCat
  describe HypothesisSubject do

    let( :experiment ) { FactoryGirl.create( :experiment_full ) }

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

      let( :subject )    { FactoryGirl.create( :subject_a ) }

      before( :each ) do
        @hypothesis = experiment.hypotheses.first

        HypothesisSubject.create(
            :hypothesis_id => @hypothesis.id,
            :subject_id => subject.id,
            :experiment_id => experiment.id )

      end

      it 'returns a HashWithIndifferentAccess' do
        counts =  HypothesisSubject.subject_counts( experiment )
        counts.should be_an_instance_of( HashWithIndifferentAccess )
      end

      it 'returns a hash of hypothesis name => count' do
        counts = HypothesisSubject.subject_counts( experiment )
        counts[ @hypothesis.name ].should eql( 1 )
      end

      it 'includes hypotheses with no subjects in db' do
        HypothesisSubject.delete_all
        counts = HypothesisSubject.subject_counts( experiment )

        counts.size.should eql( experiment.hypotheses.size )
        experiment.hypotheses.each do |hypothesis|
          counts[ hypothesis.name.to_sym ].should eql( 0 )
        end
      end

      it 'returns an empty hash if the query fails' do
        ActiveRecord::Base.connection.should_receive( :execute ).and_return( [] )
        HypothesisSubject.subject_counts( experiment )[ @hypothesis.name ].should eql( 0 )
      end

    end

    #############################################################################
    # HypothesisSubject::subject_count_sql

    describe '::subject_count_sql' do

      it 'generates SQL given an experiment' do
        HypothesisSubject.send( :subject_count_sql, experiment ).should eql_file( 'spec/data/models/hypothesis_subject_count_sql.sql' )
      end
    end

    #############################################################################
    # HypothesisSubject::subject_count_row

    describe '::subject_count_row' do

      before( :each ) do
        @counts = HashWithIndifferentAccess.new
        @hypothesis = experiment.hypotheses.first
        @subject_count = 5
      end

      it 'parses sql hash results into the counts hash' do
        row = { 'hypothesis_id' => @hypothesis.id.to_s, 'subject_count' => @subject_count.to_s }
        HypothesisSubject.subject_count_row( @counts,  row )

        @counts[ @hypothesis.id ].should eql( @subject_count )
      end

      it 'parses sql array results into the counts hash' do
        row = [ @hypothesis.id.to_s, @subject_count.to_s ]
        HypothesisSubject.subject_count_row( @counts,  row )

        @counts[ @hypothesis.id ].should eql( @subject_count )
      end

    end

  end
end
