class ClubInvitation < ApplicationRecord
  # Status constants
  PENDING = 0
  ACCEPTED = 1
  DECLINED = 2
  EXPIRED = 3

  # Associations
  belongs_to :club
  belongs_to :invited_by, polymorphic: true

  # Validations
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, presence: true
  validates :expires_at, presence: true

  # Callbacks
  before_validation :generate_token, on: :create
  before_validation :set_expiration, on: :create

  # Scopes
  scope :pending, -> { where(status: PENDING) }
  scope :accepted, -> { where(status: ACCEPTED) }
  scope :declined, -> { where(status: DECLINED) }
  scope :expired, -> { where(status: EXPIRED) }
  scope :active, -> { pending.where("expires_at > ?", Time.current) }

  # Instance methods
  def pending?
    status == PENDING
  end

  def accepted?
    status == ACCEPTED
  end

  def declined?
    status == DECLINED
  end

  def expired?
    status == EXPIRED || expires_at < Time.current
  end

  def accept!
    update!(status: ACCEPTED) if pending? && !expired?
  end

  def decline!
    update!(status: DECLINED) if pending?
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64(32)
  end

  def set_expiration
    self.expires_at = 7.days.from_now
  end
end
