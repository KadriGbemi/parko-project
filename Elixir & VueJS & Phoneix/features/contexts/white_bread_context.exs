defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  import Ecto.Query, only: [from: 2]
  alias Parko.{Park, Point, Repo}
  
  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)    
    %{}
  end

  scenario_starting_state fn state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(Parko.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Parko.Repo, {:shared, self()})
    %{}
  end
  scenario_finalize fn _status, _state ->
    #Ecto.Adapters.SQL.Sandbox.checkin(Parko.Repo)
    #Hound.end_session
    %{}
  end

  given_ ~r/^the following parking spaces  $/, fn state, %{table_data: table} ->
    table
    |> Enum.map(fn park_data -> Park.changeset(%Park{}, park_data) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^"(?<address>[^"]+)" has the following corner points which makes it completely with in 500 m radius $/,
  fn state, %{address: address, table_data: table} ->
    park = Repo.all(from p in Park, where: p.address == ^address)
           |>List.first

    table
    |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data|>Map.put(:park_id, park.id)) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^"(?<address>[^"]+)" has the following corner points which makes it partially with in 500 m radius $/,
  fn state, %{address: address, table_data: table} ->
    park = Repo.all(from p in Park, where: p.address == ^address)
           |>List.first

    table
    |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data|>Map.put(:park_id, park.id)) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^"(?<address>[^"]+)" having the following points which makes it completely out of 500 m radius $/,
  fn state, %{address: address, table_data: table} ->
    park = Repo.all(from p in Park, where: p.address == ^address)
           |>List.first

    table
    |> Enum.map(fn point_data -> Point.changeset(%Point{}, point_data|>Map.put(:park_id, park.id)) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^I go to the home page     $/, fn state ->
    navigate_to "/"
    :timer.sleep(2000);
    {:ok, state}
  end

  and_ ~r/^I fill "(?<destination_address>[^"]+)" as destination address and submit$/,
  fn state, %{destination_address: destination_address} ->
    clear_field({:id, "destination_address"})
    :timer.sleep(1000);
    fill_field({:id, "destination_address"}, destination_address)
    :timer.sleep(1000);
    click({:id, "search"})
    :timer.sleep(3000);
    {:ok, state}
  end

  then_ ~r/^I should see (?<rows>\d+) rows$/, fn state, %{rows: rows} ->
    {rows, _} = Integer.parse(rows)
    assert length(find_all_elements(:css, ".available_park")) == rows
    {:ok, state}
  end

end   
