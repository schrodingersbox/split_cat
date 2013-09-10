FactoryGirl.define do

  factory :subject_a, :class => SplitCat::Subject do
    token 'secret'
    created_at Time.now
  end

  factory :subject_b, :class => SplitCat::Subject do
    token 'foobar'
    created_at Time.now
  end

end