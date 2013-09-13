HOMEPAGE_EXPERIMENT = :homepage_4

SplitCat.configure do |config|

  config.experiment( HOMEPAGE_EXPERIMENT, 'test of homepage behavior' ) do |e|
    e.hypothesis( :a, 50, 'current behavior' )
    e.hypothesis( :b, 50, 'awesome new behavior' )
    e.goal( :clicked, 'user clicked the button' )
  end

end