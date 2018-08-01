class DateRange
  attr_accessor :start_date, :end_date

  def week_from_weeks_ago(weeks_ago)
    unless weeks_ago.nil?
      @start_date = self.class.weeks_ago_to_date(weeks_ago).beginning_of_week
      @end_date = self.class.weeks_ago_to_date(weeks_ago).end_of_week
    end
    self
  end

  def week_from_date(date)
    unless date.nil?
      @start_date = date.beginning_of_week
      @end_date = date.end_of_week
    end
    self
  end

  def current_week
    week_from_date(Date.current)
  end

  def valid?
    @start_date && @end_date
  end

  def self.weeks_ago_to_date(weeks_ago)
    Date.current.weeks_ago(weeks_ago)
  end

  def self.date_to_weeks_ago(date)
    (Date.current.end_of_week - date).to_i / 7
  end

end