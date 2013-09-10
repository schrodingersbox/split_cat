module SplitCat
  class Goal < ActiveRecord::Base
    include SplitCat::Splitable
  end
end
