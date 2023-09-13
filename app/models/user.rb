class User < ApplicationRecord
  has_many :questions, dependent: :delete_all
  has_secure_password
  before_save :downcase_nickname
  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@\S+\.\S+\z/ }
  validates :nickname,  presence: true, uniqueness: true, length: { maximum: 40 },
    format: { with: /[[:word:]]/ }
  
    def to_param
      nickname
    end

  def downcase_nickname
    nickname.downcase!
  end
end
