namespace :split_cat do

  desc 'Generate random experiment data: [n_subjects, n_experiments, max_items]'
  task :random, [ :n_subjects, :n_experiments, :max_items ] => :environment do |t,args|
    SplitCat::Random.generate( args )
  end

end

