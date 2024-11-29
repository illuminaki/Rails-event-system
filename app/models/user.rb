class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :confirmable

  has_many :events, dependent: :destroy

  # Callback after user creation to send confirmation email
  after_create :send_confirmation_email

  # Validaciones
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no tiene un formato válido" }
  validates :password, presence: true, length: { minimum: 6, message: "debe tener al menos 6 caracteres" }, if: :password_required?
 
  # Devuelve true si el usuario es normal (permission_level = 0)
  def is_normal_user?
    self.permission_level == 0
  end

  # Devuelve true si el usuario es administrador (permission_level = 1)
  def is_admin?
    self.permission_level == 1
  end

  private

  # Verifica si se necesita una contraseña (al crear o actualizar el usuario)
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  # Custom method to send confirmation instructions
  def send_confirmation_email
    # Devise already checks if the user is confirmable and sends the instructions
    send_confirmation_instructions if self.class.instance_method(:send_confirmation_instructions).owner == Devise::Models::Confirmable
  end
end
