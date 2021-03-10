# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Events.Repo.insert!(%Events.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Events.Repo
alias Events.Users.User
alias Events.UserEvents.Event

# Seeding users
user1 = Repo.insert!(%User{
  name: "user1", email: "user1@gmail.com"
})

user2 = Repo.insert!(%User{
  name: "user2", email: "user2@gmail.com"
})

user3 = Repo.insert!(%User{
  name: "user3", email: "user3@gmail.com"
})

# Creating seed datetimes
{:ok, datetime1} = NaiveDateTime.new(2021, 5, 1, 16, 0, 0)
{:ok, datetime2} = NaiveDateTime.new(2021, 6, 1, 16, 0, 0)
{:ok, datetime3} = NaiveDateTime.new(2021, 7, 1, 16, 0, 0)

# Seeding Events
event1 = %Event{
  name: "Event 1",
  description: "This is the first event's description",
  date: datetime1,
  user_id: user1.id,
}

event2 = %Event{
  name: "Event 2",
  description: "This is the second event's description",
  date: datetime2,
  user_id: user2.id,
}

event3 = %Event{
  name: "Event 3",
  description: "This is the third event's description",
  date: datetime3,
  user_id: user3.id,
}

Repo.insert!(event1)
Repo.insert!(event2)
Repo.insert!(event3)


