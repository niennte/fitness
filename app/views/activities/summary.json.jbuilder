json.summary do
  json.user do
    json.extract!(@summary[:user], :id, :name)
  end
  json.totalMinutes @summary[:total]
  json.totalMinutesByType @summary[:totals_by_type]
  json.rangeStart @summary[:range_start]
  json.rangeEnd @summary[:range_end]
end