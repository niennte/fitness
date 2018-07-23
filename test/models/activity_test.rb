require 'test_helper'

class ActivityTest < ActiveSupport::TestCase

  fixtures :users

  test 'is valid' do
    user = users(:one)
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: Date.current, minutes: 90)
    assert activity.valid?

    activity1 = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', hours: 1)
    assert activity1.valid?

    activity2 = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', hours: 1, minutes: 30)
    assert activity2.valid?

  end

  test 'is invalid unless activity type present and valid' do
    user = users(:one)

    activity_type = nil
    activity = Activity.new(user: user, activity_type: activity_type, activity_date: '2018-7-1', duration: 90)
    refute activity.valid?
    assert_not_nil activity.errors[:activity_type]

    activity_type = 'day_dreaming'
    assert_raises(Exception) {
      Activity.new(user: user, activity_type: activity_type, activity_date: '2018-7-1', duration: 90)
    }

  end

  test 'is invalid unless total duration positive' do
    user = users(:one)

    minutes = nil
    hours = nil
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', hours: hours, minutes: minutes)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]

    hours = 0
    minutes = 0
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', hours: hours, minutes: minutes)
    refute activity.valid?
    assert_not_nil activity.errors[:duration]

    hours = -1
    minutes = 1
    activity = Activity.new(user: user, activity_type: 'hiking', activity_date: '2018-7-1', hours: hours, minutes: minutes)
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
