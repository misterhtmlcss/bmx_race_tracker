class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Role constants
  OPERATOR = 0
  ADMIN = 1
  SUPER_ADMIN = 2

  # Associations
  belongs_to :club, optional: true
  has_many :sent_invitations, as: :invited_by, class_name: "ClubInvitation"

  # Validations
  validates :name, presence: true
  validates :role, presence: true
  validate :club_required_for_non_super_admin

  # Role helper methods
  def operator?
    role == OPERATOR
  end

  def admin?
    role == ADMIN
  end

  def super_admin?
    role == SUPER_ADMIN
  end

  def role_name
    case role
    when OPERATOR then "operator"
    when ADMIN then "admin"
    when SUPER_ADMIN then "super_admin"
    end
  end

  private

  def club_required_for_non_super_admin
    if !super_admin? && club.nil?
      errors.add(:club, "must exist")
    end
  end
end
