json.profile do |json|
  json.id    @user.id
  json.email @user.email
end

json.device do |json|
  json.authentication_token @device.authentication_token
end
