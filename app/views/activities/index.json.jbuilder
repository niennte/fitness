json.activities do
  json.activity do
    json.array! @activities, partial: 'activities/activity', as: :activity
  end
  json.user do
    json.extract! current_user, :id, :name
  end
end