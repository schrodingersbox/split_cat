shared_examples_for 'tokenable' do

  describe 'create' do

    it 'sets the token' do
      tokenable.should_receive( :generate_token ).and_return( 'secret' )
      tokenable.save!
    end

    it 'retries if there is a collision' do
      SecureRandom.should_receive( :urlsafe_base64 ).exactly(3).times.and_return( 'foo', 'foo', 'bar')
      tokenable.class.create!( :token => 'foo' )

      tokenable.save!
      tokenable.token.should eql( 'bar' )
    end

  end

end