require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  fixtures :users

  test 'is valid' do
    user = users(:one)
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', duration: 90)
    assert activity.valid?
  end

  test 'is invalid unless activity type valid' do
    user = users(:one)

    activity_type = nil
    activity = Activity.new(user: user, activity_type: activity_type, activity_date: '2018-7-1', duration: 90)
    refute activity.valid?
    assert_not_nil activity.errors[:activity_type]
  end

  test 'is invalid unless duration positive' do
    user = users(:one)

    duration = nil
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', duration: duration)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]

    duration = 0
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', duration: duration)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]

    duration = -1
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', duration: duration)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]

  end

  test 'is invalid unless date today or earlier' do
    user = users(:one)

    activity_date = nil
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: activity_date, duration: 90)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]

    activity_date = Date.current.tomorrow
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: activity_date, duration: 90)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]
  end

end
