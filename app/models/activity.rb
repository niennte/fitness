class Activity < ApplicationRecord
  attr_accessor :hours, :minutes

  before_validation :duration_to_minutes
  after_find :duration_to_hours_and_minutes # for partial updates to work

  enum activity_type: [:running, :walking, :hiking, :swimming, :biking, :skating, :horse_back_riding, :resistance, :balance_ball, :trx, :pint_lifting ]

  scope :inRange, ->(date_range:){where('activity_date >= ?', date_range.start_date).where('activity_date <= ?', date_range.end_date)}

  scope :forUser, -> (userId) { where('user_id = ?', userId) }

  validates :activity_type, inclusion: {
      in: activity_types,
      message: "Valid activity is required"
  }
  validates :duration, numericality: {greater_than: 0, :message => 'needs to be at least 1 minute'}
  validate :activity_date_valid_range

  def self.all_for_user(user: required)
    forUser(user.id).order('activity_date desc')
  end

  def self.in_range_for_user(user: required, date_range: required)
    inRange(date_range: date_range)
      .forUser(user.id)
      .order('activity_date asc')
  end

  def self.summary_all(user: required)
    {
        total: forUser(user).sum(:duration),
        totals_by_type:
        forUser(user)
          .group(:activity_type)
          .order('sum_duration desc')
          .sum(:duration),
        range_start:
        forUser(user)
          .minimum('activity_date'),
        range_end:
        forUser(user)
          .maximum('activity_date')
    }
  end

  def self.summary(user: required, date_range: required)
    {
        total:
        forUser(user)
          .asOfRange(date_range: date_range)
          .sum(:duration),
        totals_by_type:
        forUser(user)
          .asOfRange(date_range: date_range)
          .group(:activity_type)
          .order('sum_duration desc')
          .sum(:duration),
        range_start: date_range.start_date,
        range_end: date_range.end_date
    }
  end

  private

  def activity_date_valid_range
    if activity_date.nil? || activity_date > Date.current
      errors.add(:activity_date, "can't be in the future")
    end
  end

  def duration_to_minutes
    self.duration = hours.to_i * 60 + minutes.to_i
  end

  def duration_to_hours_and_minutes
    self.hours = duration.to_i / 60
    self.minutes = duration.to_i % 60
  end

  belongs_to :user

end
