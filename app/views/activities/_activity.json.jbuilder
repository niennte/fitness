json.extract! activity, :id, :user_id, :activity_type, :activity_date, :duration, :created_at, :updated_at
json.url activity_url(activity, format: :json)
