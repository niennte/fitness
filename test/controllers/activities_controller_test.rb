require 'test_helper'

class ActivitiesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  fixtures :activities, :users

  setup do
    @activity = activities(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get activities_url
    assert_response :success
  end

  test "should get new" do
    get new_activity_url
    assert_response :success
  end

  test "should create activity" do
    sign_in users(:one)
    assert_difference('Activity.count') do
      post activities_url, params: {
        activity:
          {
            activity_date: "2018-07-01",
            activity_type: "running",
            hours: 1,
            minutes: 30
          }
      }
    end
    assert_redirected_to activity_url(Activity.last)
  end

  test "should show own user" do
    get activity_url(@activity)
    assert_response :success
  end

  test "should not show to non-own user" do
    sign_out users(:one)
    sign_in users(:two)
    get activity_url(@activity)
    assert_response :forbidden
  end

  test "should redirect show for non logged in user" do
    sign_out users(:one)
    get activity_url(@activity)
    assert_response :redirect
  end

  test "should get edit" do
    get edit_activity_url(@activity)
    assert_response :success
  end

  test "should update for own user" do
    patch activity_url(@activity), params: {
      activity:
        {
          activity_date: "2018-07-01",
          activity_type: "walking",
          hours: 1,
          minutes: 30
        }
    }
    assert_redirected_to activity_url(@activity)
  end

  test "should not update for non-own user" do
    sign_out users(:one)
    sign_in users(:two)
    patch activity_url(@activity), params: {
      activity:
        {
          activity_date: "2018-07-01",
          activity_type: "walking",
          hours: 1,
          minutes: 30
        }
    }
    assert_response :forbidden
  end

  test "should destroy for own user" do
    assert_difference('Activity.count', -1) do
      delete activity_url(@activity)
    end
    assert_redirected_to activities_url
  end

  test "should not destroy for non-own user" do
    sign_out users(:one)
    sign_in users(:two)
    assert_no_difference('Activity.count', ) do
      delete activity_url(@activity)
    end
    assert_response :forbidden
  end
end
