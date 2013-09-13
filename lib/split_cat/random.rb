module SplitCat

  module Random

    def self.generate( args )
      n_subjects = args[ :n_subjects ].to_i
      n_experiments = args[ :n_experiments ].to_i
      max_items = args[ :max_items ].to_i

      tokens = []
      (1..n_subjects).each do |i|
        tokens << SplitCat::Subject.create.token
        puts "Token #{i} = #{tokens.last}"
      end

      puts "Experiment #{i} = #{experiment.name}"

      (1..n_experiments).each do |i|
        experiment = Experiment.create( :name => "test_#{i}_#{Time.now.to_i}" )
        n_hypotheses = 2 + rand( max_items - 2 )
        n_goals = rand( max_items )

        (0..n_hypotheses).each do |i|
          name = ('a'.ord + i).chr
          experiment.hypotheses << SplitCat::Hypothesis.create( :name => name, :weight => 1 )
        end

        (0..n_goals).each do |i|
          experiment.goals << SplitCat::Goal.create( :name => "goal_#{i}" )
        end

        experiment.save!

        tokens.each do |token|
          puts "Hypothesis #{token}"
          hypothesis = experiment.get_hypothesis( token )
          experiment.goals.each do |goal|
            if rand > 0.5
              experiment.record_goal( goal.name, token )
            end
          end
        end
      end

    end

  end

end
