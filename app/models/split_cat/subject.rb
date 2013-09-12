module SplitCat

  class Subject < ActiveRecord::Base
    include SplitCat::Tokenable

    def self.token( value = nil )
      SplitCat::Subject.create( :token => value ).token
    end
  end

end
