class CreateSplitCatHypotheses < ActiveRecord::Migration
  def change
    create_table :split_cat_hypotheses do |t|
      t.integer :experiment_id, :null => false
      t.string :name, :null => false
      t.string :description
      t.integer :weight, :null => false
      t.datetime :created_at

      t.index [ :experiment_id, :name ], :unique => true
    end
  end
end
