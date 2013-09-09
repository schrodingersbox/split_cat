class CreateSplitCatHypothesisSubjects < ActiveRecord::Migration
  def change
    create_table :split_cat_hypothesis_subjects do |t|
      t.integer :hypothesis_id
      t.integer :subject_id
      t.integer :experiment_id
      t.datetime :created_at
    end
  end
end
