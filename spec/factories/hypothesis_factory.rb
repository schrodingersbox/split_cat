FactoryGirl.define do

  factory :hypothesis_a, :class => SplitCat::Hypothesis do
    name 'hypothesis_a'
    description 'this is hypothesis a'
    created_at Time.now
  end

  factory :hypothesis_b, :class => SplitCat::Hypothesis do
    name 'hypothesis_b'
    description 'this is hypothesis b'
    created_at Time.now
  end

end