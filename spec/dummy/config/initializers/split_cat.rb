HOMEPAGE_EXPERIMENT = :homepage_2
AD_EXPERIMENT = :ad_2

SplitCat.configure do |config|

  config.experiment( HOMEPAGE_EXPERIMENT, 'test of homepage behavior' ) do |e|
    e.hypothesis( :a, 50, 'current behavior' )
    e.hypothesis( :b, 50, 'awesome new behavior' )
    e.goal( :clicked, 'user clicked the button' )
  end

  config.experiment( AD_EXPERIMENT, 'test of the ad unit' ) do |e|
    e.hypothesis( :a, 25, 'current behavior' )
    e.hypothesis( :b, 25, 'smaller ad' )
    e.hypothesis( :c, 25, 'larger ad' )
    e.hypothesis( :d, 25, 'banner ad' )
    e.goal( :clicked, 'user clicked the ad' )
  end

end