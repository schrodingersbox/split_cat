require 'spec_helper'

module SplitCat
  describe Subject do

    it_behaves_like 'tokenable' do
      let( :tokenable ) { Subject.new }
    end

    #############################################################################
    # SplitCat::token

    describe 'SplitCat::token' do

      before( :each ) do
        @token = 'foobar'
      end

      it 'creates a new Subject and returns its token' do
        subject = SplitCat::Subject.create
        subject.should_receive( :token ).and_return( @token )
        SplitCat::Subject.should_receive( :create ).and_return( subject )

        SplitCat.token
      end

      it 'saves a provided token' do
        Subject.delete_all
        SplitCat.token( @token )
        Subject.find_by_token( @token ).should be_present
      end

    end

    #############################################################################
    # database

    describe 'database' do

      it 'has columns' do
        should have_db_column( :id ).of_type( :integer )
        should have_db_column( :token ).of_type( :string )
        should have_db_column( :created_at ).of_type( :datetime )
      end

      it 'has a  unique index on token' do
        should have_db_index( :token ).unique(true)
      end

    end

  end
end
