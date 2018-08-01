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

end

