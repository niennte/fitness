require 'test_helper'

class DomainLogicTest < ActiveSupport::TestCase

  fixtures :users, :activities

  test 'makes valid summaries' do
    Activity.delete_all
    user = users(:one)

    date = Date.current.weeks_ago(2)
    range_start = date.beginning_of_week
    range_end = date.end_of_week

    activity_dataset = [
      {
        user: user,
        activity_type: 'hiking',
        activity_date: range_start.yesterday, # out of range, Sunday
        minutes: 1000
      },
      {
        user: user,
        activity_type: 'hiking',
        activity_date: range_start, # Monday
        minutes: 1
      },
      {
        user: user,
        activity_type: 'hiking',
        activity_date: range_start.tomorrow, # Tuesday
        minutes: 1
      },
      {
        user: user,
        activity_type: 'walking',
        activity_date: range_end, # Sunday
        minutes: 1
      },
      {
        user: user,
        activity_type: 'walking',
        activity_date: range_end.tomorrow, # out of range, Monday
        minutes: 1000
      }
    ]

    activity_dataset.each do |data| # Loop 6 ('each' iterator)
      Activity.new(data).save
    end

    expected_summary = {
      user: user,
      total: (1 + 1 + 1), # 3 in-range records 1 each
      totals_by_type: {
        hiking: (1 + 1), # 2 in-range occurrences of "hiking" 1 each
        walking: 1
      },
      range_start: range_start,
      range_end: range_end
    }

    expected_summary_all = {
      user: user,
      total: (1 + 1 + 1 + 1000 + 1000), # sum all records' durations
      totals_by_type: {
        hiking: (1 + 1 + 1000), # sum all occurrences of "hiking"
        walking: (1 + 1000) # sum all occurrences of "walking"
      },
      range_start: range_start.yesterday,
      range_end: range_end.tomorrow
    }

    summary = Activity.summary(user: user, date: date)
    assert_equal( expected_summary, summary.deep_symbolize_keys)

    summary_all = Activity.summary_all(user: user)
    assert_equal( expected_summary_all, summary_all.deep_symbolize_keys)

  end

end