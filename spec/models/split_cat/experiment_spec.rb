require 'spec_helper'

module SplitCat
  describe Experiment do

    describe 'associations' do

      it 'has many goals' do
        should have_many( :goals )
      end

      it 'has many hypotheses' do
        should have_many( :hypotheses )
      end

    end

    describe 'database' do

      it 'has columns' do
        should have_db_column( :id ).of_type( :integer )
        should have_db_column( :name ).of_type( :string )
        should have_db_column( :description ).of_type( :string )
        should have_db_column( :created_at ).of_type( :datetime )
      end

      it 'has a  unique index on name' do
        should have_db_index( :name ).unique(true)
      end

    end

    describe 'constraints' do

      it 'validates the presence of name' do
        should validate_presence_of( :name )
      end

      it 'validates the uniqueness of name' do
        should validate_uniqueness_of( :name )
      end

    end

  end
end
