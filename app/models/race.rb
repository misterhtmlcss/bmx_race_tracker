class Race < ApplicationRecord
  belongs_to :club

  # Validations
  validates :gate_counter, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :staging_counter, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true
  validate :validate_counter_consistency
  validate :validate_staging_greater_than_gate

  # Check if race has started
  def started?
    gate_counter.present? && staging_counter.present?
  end

  # Start the race with initial counters
  def start_race!
    self.gate_counter = 0
    self.staging_counter = 1
    save!
  end

  # Reset race counters
  def reset_race!
    self.gate_counter = nil
    self.staging_counter = nil
    save!
  end

  private

  def validate_counter_consistency
    if (gate_counter.present? && staging_counter.blank?) ||
       (gate_counter.blank? && staging_counter.present?)
      errors.add(:base, "Both counters must be set when race is started")
    end
  end

  def validate_staging_greater_than_gate
    if gate_counter.present? && staging_counter.present? && staging_counter <= gate_counter
      errors.add(:staging_counter, "must be greater than gate counter")
    end
  end
end
