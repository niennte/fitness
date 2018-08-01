require 'test_helper'

class DomainLogicTest < ActiveSupport::TestCase

  fixtures :users, :activities

  test 'makes valid summaries' do
    Activity.delete_all
    user = users(:one)

    date_range = DateRange.new.week_from_weeks_ago(2)
    range_start = date_range.start_date
    range_end = date_range.end_date

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
      total: (1 + 1 + 1), # 3 in-range records 1 each
      totals_by_type: {
        hiking: (1 + 1), # 2 in-range occurrences of "hiking" 1 each
        walking: 1
      },
      range_start: range_start,
      range_end: range_end
    }

    expected_summary_all = {
      total: (1 + 1 + 1 + 1000 + 1000), # sum all records' durations
      totals_by_type: {
        hiking: (1 + 1 + 1000), # sum all occurrences of "hiking"
        walking: (1 + 1000) # sum all occurrences of "walking"
      },
      range_start: range_start.yesterday,
      range_end: range_end.tomorrow
    }

    activities = Activity.in_range_for_user(user: user, date_range: date_range)
    summary = ActivitySummary.new(activities: activities)
    assert_equal( expected_summary, summary.to_hash)

    activities_all = Activity.all_for_user(user: user)
    summary_all = ActivitySummary.new(activities: activities_all)
    assert_equal( expected_summary_all, summary_all.to_hash)

  end

end