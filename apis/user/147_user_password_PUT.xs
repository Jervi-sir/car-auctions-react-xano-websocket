// Change user password
query "user/password" verb=PUT {
  auth = "user"

  input {
    text current_password? filters=trim
    text new_password? filters=trim
  }

  stack {
    // Get current user
    db.get user {
      field_name = "id"
      field_value = $auth.id
    } as $user
  
    // Validate new password length
    precondition (($input.new_password|strlen) >= 8) {
      error_type = "inputerror"
      error = "New password must be at least 8 characters"
    }
  
    security.check_password {
      text_password = $input.current_password
      hash_password = $user.password
    } as $isValid
  
    precondition ($isValid) {
      error_type = "accessdenied"
      error = "Passwords do not match"
    }
  
    // Update password
    db.edit user {
      field_name = "id"
      field_value = $auth.id
      data = {password: $input.new_password, updated_at: now}
    } as $updated_user
  }

  response = $updated_user.password
  history = 100
}