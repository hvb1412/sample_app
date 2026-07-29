class User < ApplicationRecord
  VALID_EMAIL_REGEX = Regexp.new(Settings.user.email.regex, Regexp::IGNORECASE)

  before_save :downcase_email

  validates :name, presence: true,
    length: {maximum: Settings.user.name.max_length}
  validates :email, presence: true,
    length: {maximum: Settings.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password

  def self.digest string
    cost = if ActiveModel::SecurePasssword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
  end

  private

  def downcase_email
    email.downcase!
  end
end
