namespace :split_cat do

  desc 'Generate a random meter sequence given arguments: [name, min, max, days]'
  task :random, [ :n_subjects, :n_experiments, :max_items ] => :environment do |t,args|
    SplitCat::Random.generate( args )
  end

end

