FactoryGirl.define do

  factory :experiment_empty, :class => SplitCat::Experiment do
    name 'test'
    description 'this is only a test'
    created_at Time.at( 1378969738 )

    factory :experiment_full, :class => SplitCat::Experiment do
      after( :build ) do |experiment|
        experiment.goals << FactoryGirl.build( :goal_a )
        experiment.goals << FactoryGirl.build( :goal_b )
        experiment.hypotheses << FactoryGirl.build( :hypothesis_a )
        experiment.hypotheses << FactoryGirl.build( :hypothesis_b )
      end
    end

  end

end