class ActivitySummary
  attr_accessor :total, :totals_by_type, :user, :range_start, :range_end

  def initialize(user:, activities: nil)
    @user = user
    @totals_by_type = Hash.new
    unless activities.nil? || activities.count == 0
      calculate_range(activities)
      calculate_totals(activities)
    end
  end

  def to_hash
    hash = {}
    instance_variables.each {|var|
      hash[var.to_s.delete("@").to_sym] = instance_variable_get(var) }
    hash
  end

  def calculate_range(activities)
    @range_start = activities.min_by{ |activity| activity.activity_date }[:activity_date]
    @range_end = activities.max_by{ |activity| activity.activity_date }[:activity_date]
  end

  private

  def calculate_totals(activities)
    activities
      .group_by { |activity| activity.activity_type }
      .map do |activity_type, records|
        @totals_by_type[activity_type.to_sym] = records.sum do |record| record.duration.to_i
      end
    end
    @total = @totals_by_type.values.sum
  end
end