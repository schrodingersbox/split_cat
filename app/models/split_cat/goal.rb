module SplitCat
  class Goal < ActiveRecord::Base

    validates_presence_of :name
    validates_uniqueness_of :name, :scope => :experiment_id

    belongs_to :experiment

  end
end
