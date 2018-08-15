module DeviseHelper
  def devise_error_messages!
    return false if resource.errors.empty?
    @messages = resource.errors.full_messages
  end
end
