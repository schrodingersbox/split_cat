module SplitCat
  module Tokenable
    extend ActiveSupport::Concern

    included do
      before_create :generate_token
    end

    protected

    def generate_token
      self.token ||= loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.where(token: random_token).exists?
      end
    end
  end
end