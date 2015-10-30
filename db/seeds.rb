# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%w(east west).each do |region|
  1.upto(31) do |day|
    user = User.create!(name: "User #{region} #{day}", profile_pic: 'http://graph.facebook.com/100001638846331/picture')
    submission = Submission.create!(
      user: user,
      name: "Some Beer #{day}",
      day: DateTime.parse("2015-10-%02d" % day),
      region: region,
      ibu: Random.rand(100) + 1,
      abv: Random.rand(10) + Random.rand + 1,
      srm: Random.rand(40),
      recipe: "No **Recipe** for _You_"
    )
    print "."
  end
end
puts ""
