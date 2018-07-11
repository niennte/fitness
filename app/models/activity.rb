class Activity < ApplicationRecord

  enum activity_type: [:running, :walking, :hiking, :swimming, :biking, :inline_skating, :horse_back_riding, :resistance, :balance_ball, :trx, :pint_lifting ]

  validates :activity_type, inclusion: { in: activity_types,
                                message: "%{value} is not a valid activity" }

  validates :duration, numericality: {greater_than: 0, :message => 'needs to be at least 1 minute'}

  validate :activity_date_valid_range

  private

  def activity_date_valid_range
    if activity_date > Date.today
      errors.add(:activity_date, "can't be in the future")
    end
  end

  belongs_to :user
end
