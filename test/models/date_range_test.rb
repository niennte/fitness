require 'test_helper'

class DateRangeTest < ActiveSupport::TestCase

  test 'is valid' do

    dates = ((Date.current - 2)..Date.current).to_a
    dates.each do |date|
      assert DateRange.new.week_from_date(date).valid?
    end

    weeks_ago = (0..2).to_a
    weeks_ago.each_index{ |i|
      assert DateRange.new.week_from_weeks_ago(i).valid?
    }

  end

  test 'is invalid' do

    refute DateRange.new.week_from_date(nil).valid?
    refute DateRange.new.week_from_weeks_ago(nil).valid?

  end

  test 'date accurately converts to weeks ago' do
    weeks_ago_set = (-1..2).to_a

    weeks_ago_set.each do |weeks_ago|
      date1 = Date.current.weeks_ago(weeks_ago).beginning_of_week
      date2 = Date.current.weeks_ago(weeks_ago).end_of_week
      dates = (date1..date2).to_a

      dates.each do |date|
        assert_equal(weeks_ago, DateRange.date_to_weeks_ago(date))
      end

    end
  end

end

