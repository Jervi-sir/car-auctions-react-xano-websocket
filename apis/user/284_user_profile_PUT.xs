// Update user profile
query "user/profile" verb=PUT {
  api_group = "user"
  auth = "user"

  input {
    text name? filters=trim
    text email? filters=trim|lower
    text phone? filters=trim
    text city? filters=trim
    text country? filters=trim
  }

  stack {
    // Get current user
    db.get "" {
      field_name = "id"
      field_value = $auth.id
    } as $user
  
    // Validate name length if provided
    precondition ($input.name == null || ($input.name|strlen) >= 2) {
      error_type = "inputerror"
      error = "Name must be at least 2 characters"
    }
  
    // If email is being changed, check if it's already in use
    var $email_changed {
      value = $input.email != null && $input.email != $user.email
    }
  
    // Check if email is already in use by another user
    var $email_exists {
      value = false
    }
  
    conditional {
      if ($email_changed) {
        db.query "" {
          where = $db.user.email == $input.email && $db.user.id != $auth.id
          return = {type: "count"}
        } as $email_count
      
        var $email_exists {
          value = $email_count > 0
        }
      }
    }
  
    conditional {
      if ($email_exists) {
        throw {
          name = ""
          value = "Email address is already in use"
        }
      }
    }
  
    !precondition (`$var.email_exists` != true) {
      error_type = "conflict"
      error = "Email address is already in use"
    }
  
    // Update user
    db.edit "" {
      field_name = "id"
      field_value = $auth.id
      data = {
        name      : $input.name|first_notnull:$user.name
        email     : $input.email|first_notnull:$user.email
        phone     : $input.phone|first_notnull:$user.phone
        country   : $input.country|first_notnull:$user.country
        city      : $input.city|first_notnull:$user.city
        updated_at: now
      }
    } as $updated_user
  
    // Prepare response
    var $response_data {
      value = {
        success: true
        message: "Profile updated successfully"
        user   : {
          id        : $var.updated_user.id
          name      : $var.updated_user.name
          email     : $var.updated_user.email
          phone     : $var.updated_user.phone
          country   : $var.country
          city      : $var.city
          updated_at: $var.updated_user.updated_at
        }
      }
    }
  }

  response = $response_data
  history = 100
}