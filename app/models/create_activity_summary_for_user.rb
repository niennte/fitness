class ActivitySummary

  attr_reader :total, :totals_by_type

  def initialize(current_user_id)
    calculate_total(current_user_id)
    calculate_totals_by_type(current_user_id)
  end

  def calculate_total(user_id)
    @total = Activity.forUser(user_id).weekly.sum(:duration)
  end

  def calculate_totals_by_type(user_id)
    @totals_by_type =
        Activity
            .forUser(user_id)
            .weekly
            .group(:activity_type)
            .order('sum_duration desc')
            .sum(:duration)
  end

end
