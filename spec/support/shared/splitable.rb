# let( :experiment) and let( :association ) before calling

shared_examples_for 'splitable' do

  describe 'associations' do

    it 'belongs to an experiment with an inverse relationship' do
      should belong_to( :experiment )
      association.first.experiment.should be( experiment )
    end

  end

  describe 'database' do

    it 'has columns' do
      should have_db_column( :id ).of_type( :integer )
      should have_db_column( :experiment_id ).of_type( :integer )
      should have_db_column( :name ).of_type( :string )
      should have_db_column( :description ).of_type( :string )
    end

    it 'has a compound unique index on  name and experiment id' do
      should have_db_index( [ :experiment_id, :name ] ).unique(true)
    end

  end

  describe 'constraints' do

    it 'validates the presence of name' do
      should validate_presence_of( :name )
    end

    it 'validates the uniqueness of name scoped to experiment' do
      should validate_uniqueness_of( :name ).scoped_to( :experiment_id )
    end

  end

end