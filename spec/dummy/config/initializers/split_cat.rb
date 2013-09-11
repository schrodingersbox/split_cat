SplitCat.configure do |config|

  config.experiment( :homepage, 'test of homepage behavior' ) do |e|
    e.add_hypothesis( :a, 50, 'current behavior' )
    e.add_hypothesis( :b, 50, 'awesome new behavior' )
    e.add_goal( :clicked, 'user clicked the button' )
  end

  config.experiment( :ad, 'test of the ad unit' ) do |e|
    e.add_hypothesis( :a, 25, 'current behavior' )
    e.add_hypothesis( :b, 25, 'smaller ad' )
    e.add_hypothesis( :c, 25, 'larger ad' )
    e.add_hypothesis( :d, 25, 'banner ad' )
    e.add_goal( :clicked, 'user clicked the ad' )
  end

end