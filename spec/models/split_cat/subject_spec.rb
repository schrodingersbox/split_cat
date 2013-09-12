require 'spec_helper'

module SplitCat
  describe Subject do

    it_behaves_like 'tokenable' do
      let( :tokenable ) { Subject.new }
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
