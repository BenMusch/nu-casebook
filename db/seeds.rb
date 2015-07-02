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