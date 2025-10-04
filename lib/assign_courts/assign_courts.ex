defmodule Leet.AssignCourts do
  @moduledoc """
  Documentation for Assigning Courts to Non-Overlapping Requests.
  """

  @spec sort_requests(list(map())) :: list(map())
  def sort_requests(requests) do
    Enum.sort_by(requests, fn r -> {r.start_time, r.finish_time - r.start_time, r.id} end)
  end

  def assign_courts(unassigned_requests) do
    unassigned_requests = sort_requests(unassigned_requests)

    assign_courts([], unassigned_requests)
    |> Enum.map(fn c -> Map.take(c, [:id, :bookings]) end)
    |> Enum.sort_by(fn c -> {c.id} end)
  end

  def assign_courts([], unassigned_requests) do
    [e | o] = unassigned_requests
    conflicts = get_conflicting_requests(e.finish_time, o)

    assigned_requests = [e] ++ conflicts

    courts =
      assigned_requests
      |> Enum.sort_by(fn r -> r.id end)
      |> Enum.with_index()
      |> Enum.map(fn {req, index} ->
        %{
          id: index + 1,
          bookings: [req],
          min_start: req.start_time,
          max_finish: req.finish_time
        }
      end)

    unassigned_requests = get_unassiged_requests(assigned_requests, unassigned_requests)

    assign_courts(courts, unassigned_requests)
  end

  def assign_courts(courts, []), do: courts

  def assign_courts(courts, requests) do
    next_court_id = get_max_court_id(courts)

    {_, updated_courts} =
      Enum.map_reduce(
        requests,
        courts,
        fn u_req, court_acc ->
          allowed_courts =
            court_acc
            |> Enum.reject(fn court -> u_req.start_time < court.max_finish end)
            |> Enum.sort_by(fn r -> {r.max_finish} end)

          case allowed_courts do
            [] ->
              # no courts can acoomodate, generate a new court
              next_court_id = next_court_id + 1

              new_c =
                %{
                  id: next_court_id,
                  bookings: [u_req],
                  min_start: u_req.start_time,
                  max_finish: u_req.finish_time
                }

              {nil, court_acc ++ [new_c]}

            _ ->
              c = List.first(allowed_courts)
              idx = Enum.find_index(court_acc, fn c_acc -> c.id == c_acc.id end)

              updated_c =
                c
                |> Map.put(:max_finish, u_req.finish_time)
                |> Map.put(:bookings, c.bookings ++ [u_req])

              {nil, List.replace_at(court_acc, idx, updated_c)}
          end
        end
      )

    updated_courts
  end

  def get_max_court_id(courts) do
    courts
    |> Enum.map(fn c -> Map.get(c, :id) end)
    |> Enum.max()
  end

  def get_unassiged_requests(assigned_reqs, reqs) do
    assigned_ids = Enum.map(assigned_reqs, fn r -> r.id end)

    Enum.reject(reqs, fn r -> r.id in assigned_ids end)
  end

  def get_conflicting_requests(finish_time, other_reqs) do
    Enum.reject(other_reqs, fn r -> finish_time < r.start_time end)
  end
end
