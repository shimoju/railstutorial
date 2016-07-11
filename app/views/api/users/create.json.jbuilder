unless @user.errors.messages.empty?
  json.message "Created"
else
  json.message "Validation Failed"
  json.errors @user.errors.messages
end
