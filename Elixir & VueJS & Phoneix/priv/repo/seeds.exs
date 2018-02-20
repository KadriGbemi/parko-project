# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Parko.Repo.insert!(%Parko.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will halt execution if something goes wrong.

#add aliases
alias Parko.{Park,Point,User,Repo}
#adding some parking spaces in the database for the perpose of testing 
# [
#  %{address: "Kivi 25", zone: "A", lat: 58.383163, lng: 26.730891},
#  %{address: "Raatuse 20", zone: "B", lat: 58.382156, lng: 26.730301},
#  %{address: "Põik 4", zone: "B", lat: 58.382125, lng: 26.731899},
#  %{address: "Kivi 19", zone: "A", lat: 58.382611, lng: 26.729871}
# ]
# |> Enum.map(fn park_data -> Park.changeset(%Park{}, park_data) end)
# |> Enum.each(fn changeset -> Repo.insert!(changeset) end)


[%{name: "Bruno produit", username: "bruno", password: "foo", email: "bruno@gmail.com"},
%{name: "Kadri Gbemi", username: "Kadri", password: "gbemisola", email: "kadri.oluwagbemi@gmail.com"},
%{name: "Fred Flintstone", username: "fred", password: "parool", email: "fred@gmail.com"},
%{name: "Barney Rubble", username: "barney", password: "parool", email: "barney.rubble@gmail.com"}
]

|> Enum.each(fn user -> Repo.insert!(User.changeset(%User{},user) )end)

park1 = Repo.insert!(Park.changeset(%Park{},%{address: "Tasuta parkla, Raatuse 27", zone: "A", lat: 58.381858, lng: 26.730872, is_road: true, available_space: 40, total_space: 40}))
             
points1 = [
          %{park_id: park1.id, lat: 58.381895, lng: 26.730692},
          %{park_id: park1.id,lat: 58.382165, lng: 26.731779},
          %{park_id: park1.id,lat: 58.381646, lng: 26.732235},
          %{park_id: park1.id,lat: 58.381442, lng: 26.731192},
          ]
          |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data) end)
          |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
              
park2 = Repo.insert!(Park.changeset(%Park{},%{address: "Põik 16-4", zone: "A", lat: 58.381406, lng: 26.732642, is_road: true, available_space: 10, total_space: 10}))
                          
points2 = [
          %{park_id: park2.id, lat: 58.382175, lng: 26.731963},
          %{park_id: park2.id,lat: 58.382221, lng: 26.732116}, 
          %{park_id: park2.id,lat: 58.380783, lng: 26.733218},
          %{park_id: park2.id,lat: 58.380725, lng: 26.733086}
          ]
          |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data) end)
          |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
             
park3 = Repo.insert!(Park.changeset(%Park{},%{address: "Munga 10-4", zone: "B", lat: 58.381691, lng: 26.719129, is_road: false, available_space: 10, total_space: 10}))

points3 = [
          %{park_id: park3.id, lat: 58.381410, lng: 26.718207},
          %{park_id: park3.id,lat: 58.381353, lng: 26.718292},
          %{park_id: park3.id,lat: 58.381972, lng: 26.719988},
          %{park_id: park3.id,lat: 58.381916, lng: 26.720030},
          ]
          |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data) end)
          |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

park4 = Repo.insert!(Park.changeset(%Park{},%{address: "Kivi 27", zone: "B", lat: 58.382990, lng: 26.731717, is_road: false, available_space: 10, total_space: 10}))
                          
points4 = [
          %{park_id: park4.id, lat: 58.382737, lng: 26.730645},
          %{park_id: park4.id, lat: 58.382577, lng: 26.731061}, 
          %{park_id: park4.id, lat: 58.382795, lng: 26.731893},
          %{park_id: park4.id, lat: 58.383093, lng: 26.731389}
          ]
          |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data) end)
          |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
          
             
park5 = Repo.insert!(Park.changeset(%Park{},%{address: "Pikk 19", zone: "B", lat: 58.383632, lng: 26.732548, is_road: true, available_space: 10, total_space: 10}))

points5 = [
          %{park_id: park5.id, lat: 58.383759, lng: 26.732155},
          %{park_id: park5.id,lat: 58.383390,  lng: 26.732788},
          %{park_id: park5.id,lat: 58.383551,  lng: 26.732963},
          %{park_id: park5.id,lat: 58.383908,  lng: 26.732331},
          ]
          |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data) end)
          |> Enum.each(fn changeset -> Repo.insert!(changeset) end)



# Munga 10-6
# 51005 Tartu
# 58.381691, 26.719129

# Jakobi 5
# 51005 Tartu
# 58.381410, 26.718207

# Jakobi
# 51005 Tartu
# 58.381353, 26.718292

# Tartu Muusik
# Jaani 4, 51005 Tartu
# 58.381972, 26.719988

# Tartu Muusik
# Jaani 4, 51005 Tartu
# 58.381916, 26.720030

