module ApplicationHelper
  def current_class?(test_path)
    return 'current' if @_request.fullpath == test_path
  end
end
