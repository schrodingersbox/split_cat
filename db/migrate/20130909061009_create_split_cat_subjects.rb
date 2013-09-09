class CreateSplitCatSubjects < ActiveRecord::Migration
  def change
    create_table :split_cat_subjects do |t|
      t.integer :user_id
      t.string :token
      t.datetime :created_at
    end
  end
end
