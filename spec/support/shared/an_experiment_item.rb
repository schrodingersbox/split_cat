shared_examples_for 'an experiment item' do

  before( :each ) do
    @item = FactoryGirl.build( factory )
  end

  describe 'associations' do

    it 'belongs to an experiment' do
      @experiment = FactoryGirl.create( :empty_experiment )
      @item = FactoryGirl.create( factory, :experiment_id => @experiment.id )

      @item.experiment.should eql( @experiment )
    end

  end

  describe 'attributes' do

    it 'has a name' do
      name = FactoryGirl.build( factory ).name
      @item.name = name
      @item.name.should eql( name )
    end

    it 'has a description' do
      description = FactoryGirl.build( factory ).description
      @item.description = description
      @item.description.should eql( description )
    end

    it 'has a created_at' do
      created_at = FactoryGirl.build( factory ).created_at
      @item.created_at = created_at
      @item.created_at.should eql( created_at )
    end

  end

  describe 'constraints' do

    it 'validates the presence of name' do
      @item.valid?.should be_true
      @item.name = nil
      @item.valid?.should be_false
      @item.errors.messages[ :name ].should eql( ["can't be blank"] )
    end

    it 'validates the uniqueness of names within an experiment but not across them' do
      experiment_a = FactoryGirl.create( :empty_experiment, :name => :experiment_a  )
      experiment_b = FactoryGirl.create( :empty_experiment, :name => :experiment_b  )
      FactoryGirl.create( factory, :experiment_id => experiment_a.id )

      @item.valid?.should be_true
      @item.experiment = experiment_b
      @item.valid?.should be_true
      @item.experiment = experiment_a
      @item.valid?.should be_false
    end

  end

end