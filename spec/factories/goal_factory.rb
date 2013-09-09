FactoryGirl.define do

  factory :goal_a, :class => SplitCat::Goal do
    name 'goal_a'
    description 'this is goal a'
    created_at Time.now
  end

  factory :goal_b, :class => SplitCat::Goal do
    name 'goal_b'
    description 'this is goal b'
    created_at Time.now
  end

end