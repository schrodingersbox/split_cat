class CreateSplitCatGoalSubjects < ActiveRecord::Migration
  def change
    create_table :split_cat_goal_subjects do |t|
      t.integer :goal_id
      t.integer :subject_id
      t.integer :experiment_id
      t.integer :hypothesis_id
      t.datetime :created_at
    end
  end
end
