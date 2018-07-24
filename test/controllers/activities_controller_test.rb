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

  test "should get index as json" do
    get activities_url, as: :json
    assert_response :success
  end

  test "should get list" do
    get list_url
    assert_response :success
  end

  test "should get list as json" do
    get list_url, as: :json
    assert_response :success
  end

  test "should get summary" do
    get summary_url
    assert_response :success
  end

  test "should get summary as json" do
    get summary_url, as: :json
    assert_response :success
  end

  test "should get summary-all" do
    get summary_all_url
    assert_response :success
  end

  test "should get summary-all as json" do
    get summary_all_url, as: :json
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

  test "should create activity as json" do
    sign_in users(:one)
    assert_difference('Activity.count') do
      post activities_url, params: {
        activity:
          {
            activity_date: "2018-07-01",
            activity_type: "horse_back_riding",
            hours: 1,
            minutes: 30
          }
      }, as: :json
    end
    assert_response :created
    assert_match("horse_back_riding", response.parsed_body.to_s )
  end

  test "should show to owning user" do
    get activity_url(@activity)
    assert_response :success
  end

  test "should show as json to owning user" do
    get activity_url(@activity), as: :json
    assert_response :success
  end

  test "should not show to non-owning user" do
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

  test "should update for owning user" do
    patch activity_url(@activity), params: {
      activity:
        {
          activity_date: "2018-07-01",
          activity_type: "trx",
          hours: 1,
          minutes: 30
        }
    }
    assert_redirected_to activity_url(@activity)
  end

  test "should update as json for owning user" do
    patch activity_url(@activity), params: {
      activity:
        {
          activity_type: "pint_lifting"
        }
    }, as: :json
    assert_response :success
    assert_match("pint_lifting", response.parsed_body.to_s  )
  end

  test "should not update for non-owning user" do
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

  test "should destroy for owning user" do
    assert_difference('Activity.count', -1) do
      delete activity_url(@activity)
    end
    assert_redirected_to activities_url
  end

  test "should destroy as json for owning user" do
    assert_difference('Activity.count', -1) do
      delete activity_url(@activity), as: :json
    end
    assert_response 204
  end

  test "should not destroy for non-owning user" do
    sign_out users(:one)
    sign_in users(:two)
    assert_no_difference('Activity.count', ) do
      delete activity_url(@activity)
    end
    assert_response :forbidden
  end
end
