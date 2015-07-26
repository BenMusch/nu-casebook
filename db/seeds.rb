User.create!(email: "muschol.b@husky.neu.edu",
             password:              "foobar",
             password_confirmation: "foobar",
             activated: true,
             activated_at: Time.zone.now)

20.times do |n|
  email  = "a" * (n + 1)
  email += ".b@husky.neu.edu"
  password = "password"
  User.create!(email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

100.times do |n|
  link = "http://www.google.com/#{n}"
  title = "Case Number #{n}"
  case_statement = "This is where the case statement would go"
  Case.create!(link:           link,
               title:          title,
               opp_choice:     false,
               case_statement: case_statement)
end
