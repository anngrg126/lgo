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
    
    if messages.include? "Email"
      html = "<label for='user_email' class='is-invalid-label'>Email</label><input id='user_email' autofocus='autofocus' value='' name='user[email]' type='email' class='is-invalid-input'><span class='form-error is-visible'>#{messages_array[errormessage]}</span>".html_safe
    else
      html = "<label for='user_email'>Email</label><input id='user_email' autofocus='autofocus' value='' name='user[email]' type='email'>".html_safe
    end
  end

  def devise_password_field
    messages = resource.errors.full_messages.join(" ")
    messages_array = resource.errors.full_messages
    errormessage = messages_array.index{|s| s.include?("Password")}
    
    if messages.include? "Password"
      html = "<label for='user_password' class='is-invalid-label'>Password</label><input id='user_password' autocomplete='off' name='user[password]' type='password' class='is-invalid-input form-control'><span class='form-error is-visible'>#{messages_array[errormessage]}</span>".html_safe
    else
    html = "<label for='user_password'>Password</label><input class='form-control' id='user_password' autocomplete='off' name='user[password]' type='password'>".html_safe
    end
  end
end