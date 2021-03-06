# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Category.create(title: "Action")
Category.create(title: "Comedy")
Category.create(title: "Cartoon")
Category.create(title: "Drama")
Category.create(title: "TV")

Video.create(title: 'Futurama', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'South Park', description: 'Amazing Cartoon!', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Monk', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Simpsons', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Meet the simpsons', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Montana', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Greats of Sports', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Dr WHO', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Season 7', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Narcos', description: 'Lorem ipsum', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")
Video.create(title: 'Nicholas Cage', description: 'Great Film!', category: Category.all.sample, small_cover_url: "/tmp/#{['futurama', 'south_park', 'family_guy'].sample}.jpg", large_cover_url: "/tmp/monk_large.jpg")

kevin = User.create(full_name: "Kevin Tea", password: "password", email: "kevin@example.com")
Review.create(video: Video.first, user: kevin, rating: 3, content: "Awesome video. Would highly recommmend")
Review.create(video: Video.first, user: User.first, rating: 5, content: "Fantastic video. Would highly recommmend")
Review.create(video: Video.second, user: kevin, rating: 5, content: "Awesome video. Would highly recommmend")

kevin = User.where("full_name iLIKE ?" , "%kevin%").first
chris = User.create(full_name: "Chris Tea", password: "passwword", email: "chris@example.com")
alice = User.create(full_name: "Alice Tea", password: "passwword", email: "alice@example.com")
Relationship.create(leader: chris, follower: kevin)
Relationship.create(leader: alice, follower: kevin)

