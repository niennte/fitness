module ApplicationHelper
  def css_active(isActive)
    isActive ? 'active' : ''
  end

  def css_invalid(isInvalid)
    isInvalid ? 'has-errors alert alert-danger' : ''
  end
end
