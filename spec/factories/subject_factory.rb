FactoryGirl.define do

  factory :subject_a, :class => SplitCat::Subject do
    user_id 12
    token 'abcxyz123'
    created_at Time.now
  end

end