module SplitCat

  def self.token( value = nil )
    SplitCat::Subject.create( :token => value ).token
  end

  class Subject < ActiveRecord::Base
    include SplitCat::Tokenable
  end
end
