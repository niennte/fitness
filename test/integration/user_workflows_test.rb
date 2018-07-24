require 'test_helper'

class UserWorkflowsTest < ActionDispatch::IntegrationTest

  fixtures :activities, :users

  setup do
    @user = users(:one)
  end

  test 'user can sign in' do
    post user_session_path, params: { user: { email: @user.email, password: 'qwerty1' } }
    assert_response :redirect
  end

  test 'after signing in, user can create activity' do
    post user_session_path, params: { user: { email: @user.email, password: 'qwerty1' } }
    assert_response :redirect

    assert_difference('Activity.count') do
      post activities_url, params: {
        activity:
          {
            activity_date: Date.current,
            activity_type: 'running',
            hours: 1,
            minutes: 30
          }
      }
    end
    assert_redirected_to activity_url(Activity.last)
  end

  test 'after signing in, user can edit their activity' do
    post user_session_path, params: { user: { email: @user.email, password: 'qwerty1' } }
    assert_response :redirect

    get edit_activity_path(@user.activities.first)
    assert_response :success
    patch activity_path(@user.activities.first), params: { activity: { activity_type: 'pint_lifting'} }
    assert_equal 'pint_lifting', @user.activities.first.activity_type
    assert_redirected_to activity_url(@user.activities.first)
  end

  test 'after signing in, user can delete their activity' do
    post user_session_path, params: { user: { email: @user.email, password: 'qwerty1' } }
    assert_response :redirect
    assert_difference('Activity.count', -1) do
      delete activity_url(@user.activities.first)
    end
  end

end