module ActivitiesHelper

  def render_timespan(total_mins)
    "#{total_mins_to_partial_hrs(total_mins)}h #{total_mins_to_partial_mins(total_mins) % 60}min"
  end

  def total_mins_to_partial_hrs(total_mins)
    total_mins.to_i / 60
  end

  def total_mins_to_partial_mins(total_mins)
    total_mins.to_i % 60
  end

  def render_date(date)
    date.strftime("%a, %d %b %Y")
  end

  def render_week_title(weeks_ago)
    week = DateRange.new.week_from_weeks_ago(weeks_ago)
    "#{render_date(week.start_date)} - #{render_date(week.end_date)}"
  end

  def date_to_weeks_ago(date)
    DateRange.date_to_weeks_ago(date)
  end

end