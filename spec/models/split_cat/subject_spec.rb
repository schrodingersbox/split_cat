require 'spec_helper'

module SplitCat
  describe Subject do

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

    describe 'validations' do

      it 'validates the presence of name' do
        should validate_presence_of( :token )
      end

      it 'validates the uniqueness of name' do
        should validate_uniqueness_of( :token )
      end

    end

  end
end
