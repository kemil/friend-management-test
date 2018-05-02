# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if User.count == 0
  a = User.create(name: 'Jhon Doe' , email: 'jhon@doe.com' , address: 'New York' , phone: '111111111')
  b = User.create(name: 'David Lewis', email: 'david@lewis.com', address: 'Chicago', phone: '222222222')
  c = User.create(name: 'Tim Cook', email: 'time@cook.com', address: 'Bandung', phone: '333333333')
  d = User.create(name: 'Doe Jhon', email: 'doe@jhon.com', address: 'Jakarta' , phone: '44444444')
  e = User.create(name: 'Lewis David', email: 'lewis@david.com', address: 'Singapore', phone: '555555555')
  f = User.create(name: 'Cook Tim', email: 'cook@tim.com', address: 'Kuala Lumpur', phone: '666666666')
end


if Friend.count == 0
  Friend.create(user_id: a.id, friend_id: e.id)
  Friend.create(user_id: a.id, friend_id: c.id)
  Friend.create(user_id: b.id, friend_id: a.id)
  Friend.create(user_id: c.id, friend_id: d.id)
end
