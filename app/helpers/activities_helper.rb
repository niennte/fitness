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

  def beginning_of_week(weeks_ago)
    weeks_ago_to_date(weeks_ago).beginning_of_week
  end

  def end_of_week(weeks_ago)
    weeks_ago_to_date(weeks_ago).end_of_week
  end

  def render_week_title(weeks_ago)
    "#{render_date(beginning_of_week(weeks_ago))} - #{render_date(end_of_week(weeks_ago))}"
  end

  def weeks_ago_to_date(weeks_ago)
    Date.current.weeks_ago(weeks_ago)
  end

  def date_to_weeks_ago(date)
    (Date.current.end_of_week - date).to_i / 7
  end

end