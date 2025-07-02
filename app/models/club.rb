class Club < ApplicationRecord
  # Associations
  has_many :users, dependent: :restrict_with_exception
  has_one :race, dependent: :destroy
  has_many :club_invitations, dependent: :destroy

  # Scopes
  scope :active, -> { where(active: true) }

  # Validations
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :city, presence: true
  validates :country, presence: true
  validates :slug, format: {
    with: /\A[a-z0-9\-]+\z/,
    message: "only lowercase letters, numbers, and hyphens allowed"
  }

  # Callbacks
  after_create :create_race_record

  private

  def create_race_record
    create_race!
  end
end
