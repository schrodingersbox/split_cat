FactoryGirl.define do

  factory :empty_experiment, :class => SplitCat::Experiment do
    name 'test'
    description 'this is only a test'
    created_at Time.now
  end

end