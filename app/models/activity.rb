class Activity < ApplicationRecord
  attr_accessor :hours, :minutes

  before_validation :duration_to_minutes
  after_find :duration_to_hours_and_minutes # for partial updates to work

  enum activity_type: [:running, :walking, :hiking, :swimming, :biking, :skating, :horse_back_riding, :resistance, :balance_ball, :trx, :pint_lifting ]

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

  private

  scope :inRange, ->(date_range:){where('activity_date >= ?', date_range.start_date).where('activity_date <= ?', date_range.end_date)}

  scope :forUser, -> (userId) { where('user_id = ?', userId) }

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
