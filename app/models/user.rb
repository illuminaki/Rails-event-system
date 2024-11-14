class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :confirmable

  has_many :events, dependent: :destroy

  # Callback after user creation to send confirmation email
  after_create :send_confirmation_email

  private

  # Custom method to send confirmation instructions
  def send_confirmation_email
    # Devise already checks if the user is confirmable and sends the instructions
    send_confirmation_instructions if self.class.instance_method(:send_confirmation_instructions).owner == Devise::Models::Confirmable
  end
end
