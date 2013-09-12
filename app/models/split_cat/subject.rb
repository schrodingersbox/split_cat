module SplitCat

  class Subject < ActiveRecord::Base
    include SplitCat::Tokenable
  end

end
