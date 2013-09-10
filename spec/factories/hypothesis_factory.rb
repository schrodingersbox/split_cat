FactoryGirl.define do

  factory :hypothesis_a, :class => SplitCat::Hypothesis do
    name 'hypothesis_a'
    description 'this is hypothesis a'
    weight 10
    created_at Time.now
  end

  factory :hypothesis_b, :class => SplitCat::Hypothesis do
    name 'hypothesis_b'
    description 'this is hypothesis b'
    weight 90
    created_at Time.now
  end

end