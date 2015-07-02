class ApplicationMailer < ActionMailer::Base
  default from: "noreply@nu-casebook.herokuapp.com"
  layout 'mailer'
end
