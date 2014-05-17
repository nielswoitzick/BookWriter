module UsersHelper

  def resource
    instance_variable_get(:"@#{resource_name}")
  end

  def resource_name
    'user'
  end

end
