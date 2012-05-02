namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(:name => "WSA User",
                       :email => "wsa@wsa.org",
                       :password => "random",
                       :password_confirmation => "random")
  admin.toggle!(:admin)
  5.times do |n|
    name = Faker::Name.name
    email = "wsa-#{n+1}@wsa.org"
    password = "password"
    User.create!(:name => name,
                 :email => email,
                 :password => password,
                 :password_confirmation => password)
  end
end

def make_microposts
  5.times do
    User.all(:limit => 6).each do |user|
      user.microposts.create!(:content => Faker::Lorem.sentence(5))
    end
  end
end

def make_relationships
  users = User.all
  user  = users.first
  following = users[1..2]
  followers  = users[3..5]
  following.each { |followed| user.follow!(followed) }
  followers.each { |follower| follower.follow!(user) }
end

def make_country
  5.times do |n|
    country = Faker::Country.country
  end
end