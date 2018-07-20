class Activity < ApplicationRecord
  attr_accessor :hours, :minutes

  before_validation :duration_to_minutes
  after_find :duration_to_hours_and_minutes

  enum activity_type: [:running, :walking, :hiking, :swimming, :biking, :skating, :horse_back_riding, :resistance, :balance_ball, :trx, :pint_lifting ]

  scope :ofWeek, -> (date: Date.current) { where('activity_date >= ?', date.beginning_of_week).where('activity_date <= ?', date.end_of_week) }
  scope :forUser, -> (userId ) { where('user_id = ?', userId) }

  validates :activity_type, inclusion: { in: activity_types,
                                message: "%{value} is not a valid activity" }
  validates :duration, numericality: {greater_than: 0, :message => 'needs to be at least 1 minute'}
  validate :activity_date_valid_range

  # user_for_summary is a stub
  # to communicate the parameter is required
  def self.summary(user: user_for_summary, date: Date.current)
    {
      total:
        forUser(user)
        .ofWeek(date: date)
        .sum(:duration),
      totals_by_type:
        forUser(user)
        .ofWeek(date: date)
        .group(:activity_type)
        .order('sum_duration desc')
        .sum(:duration)
    }
  end

  private

  def activity_date_valid_range
    if activity_date > Date.today
      errors.add(:activity_date, "can't be in the future")
    end
  end


  def duration_to_minutes
    self.duration = hours.to_i*60 + minutes.to_i
  end


  def duration_to_hours_and_minutes
    self.hours = duration.to_i / 60
    self.minutes = duration.to_i % 60
  end

  belongs_to :user
end
