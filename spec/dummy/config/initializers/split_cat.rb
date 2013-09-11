SplitCat.configure do |config|

  config.experiment( :homepage_1 ) do |e|
    e.add_hypothesis( :a, 50 )
    e.add_hypothesis( :b, 50 )
    e.add_goal( :clicked )
  end

  config.experiment( :ad_1 ) do |e|
    e.add_hypothesis( :a, 25 )
    e.add_hypothesis( :b, 25 )
    e.add_hypothesis( :c, 25 )
    e.add_hypothesis( :d, 25 )
    e.add_goal( :clicked )
  end

end