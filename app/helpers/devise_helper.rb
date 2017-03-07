module DeviseHelper
  
  def devise_error_messages!
    return "" unless devise_error_messages?

    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)
    html = "<div class='callout alert' data-closable><button class='close-button' aria-label='dismiss alert' type='button' data-close><span aria-hidden='true'>&times;</span></button><p><i class='fi-alert'></i>#{sentence}</p>
    </div>".html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end

  def devise_email_field
    messages = resource.errors.full_messages.join(" ")
    messages_array = resource.errors.full_messages
    errormessage = messages_array.index{|s| s.include?("Email")}
    
    unless errormessage.nil?
      content_tag(:label, "Email", for: "user_email", class: "is-invalid-label") +
      tag(:input, id:'user_email', name:'user[email]', type:'email', class:'is-invalid-input') +
#      content_tag(:span, "#{messages_array[errormessage]}", class:'form-error is-visible')
      if messages_array[errormessage].include?('has already been taken')
        content_tag(:span, "#{messages_array[errormessage]}", class:'form-error is-visible') do
          content_tag(:span, "Returning users, please ", class: "subtext") +
          link_to("login", new_user_session_path, class: "subtext") +
          content_tag(:span, ".", class: "subtext")
        end
      else
        content_tag(:span, "#{messages_array[errormessage]}", class:'form-error is-visible')
      end
    else
#      content_tag(:label, "Email", for: "user_email") +
      tag(:input, id: "user_email", name: "user[email]", type: "email", placeholder: "Email")
    end
  end

  def devise_password_field
    messages = resource.errors.full_messages.join(" ")
    messages_array = resource.errors.full_messages
    errormessage = messages_array.index{|s| s.include?("Password") && s.exclude?("confirmation")}
    
    unless errormessage.nil?
      content_tag(:label, "Password", for: "user_password", class: "is-invalid-label") +
      tag(:input, id: "user_password", autocomplete: "off", name: "user[password]", type: "password", class: "is-invalid-input form-control") +
      content_tag(:span, "#{messages_array[errormessage]}", class: "form-error is-visible")
    else
#      content_tag(:label, "Password", for: "user_password") +
      tag(:input, id: "user_password", autocomplete: "off", name: "user[password]", type: "password", placeholder: "Password")
    end
  end
  
  def devise_token_field
    messages = resource.errors.full_messages.join(" ")
    messages_array = resource.errors.full_messages
    errormessage = messages_array.index{|s| s.include?("token")}
    if messages.include? "token"
    content_tag(:div, 
      content_tag(:div, "#{messages_array[errormessage]}") +
      content_tag(:button, 
        content_tag(:span, "x"), class: "close-button", type: "button", data: {close: ''}), class: "callout alert", data: {closable: ''})
    end
  end
  def devise_password_confirmation_field
    messages = resource.errors.full_messages.join(" ")
    messages_array = resource.errors.full_messages
    errormessage = messages_array.index{|s| s.include?("Password confirmation")}
    
    if messages.include? "Password confirmation" 
      html = "<label for='user_password_confirmation' class='is-invalid-label'>Confirm new password</label><input id='user_password_confirmation' autocomplete='off' name='user[password_confirmation]' type='password' class='is-invalid-input form-control'><span class='form-error is-visible'>#{messages_array[errormessage]}</span>".html_safe
    else
#      content_tag(:label, "Confirm new password", for: "user_password_confirmation") +
      tag(:input, id: "user_password_confirmation", autocomplete: "off", name: "user[password_confirmation]", type: "password", placeholder: "Confirm Password", class: "form-control")
    end
  end
  def devise_current_password_field
    messages = resource.errors.full_messages.join(" ")
    messages_array = resource.errors.full_messages
    errormessage = messages_array.index{|s| s.include?("Current password")}
    
    if messages.include? "Current password" 
      html = "<label for='user_current_password' class='is-invalid-label'>Current Password</label><input id='user_current_password' autocomplete='off' name='user[current_password]' type='password' class='is-invalid-input form-control'><span class='form-error is-visible'>#{messages_array[errormessage]}</span>".html_safe
    else
      html = "<label for='user_current_password'>Current password</label><input class='form-control' id='user_current_password' autocomplete='off' name='user[current_password]' type='password'>".html_safe
    end
  end
end