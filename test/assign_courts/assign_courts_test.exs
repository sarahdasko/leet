defmodule Leet.AssignCourtsTest do
  use ExUnit.Case

  @requests [
    %{id: 1, start_time: 0, finish_time: 5},
    %{id: 2, start_time: 7, finish_time: 10},
    %{id: 3, start_time: 0, finish_time: 2},
    %{id: 4, start_time: 3, finish_time: 4},
    %{id: 5, start_time: 5, finish_time: 6},
    %{id: 6, start_time: 2, finish_time: 7},
    %{id: 7, start_time: 8, finish_time: 13}
  ]

  @court_bookings [
    %{
      id: 1,
      bookings: [
        %{id: 1, start_time: 0, finish_time: 5},
        %{id: 2, start_time: 7, finish_time: 10}
      ]
    },
    %{
      id: 2,
      bookings: [
        %{id: 3, start_time: 0, finish_time: 2},
        %{id: 4, start_time: 3, finish_time: 4},
        %{id: 5, start_time: 5, finish_time: 6},
        %{id: 7, start_time: 8, finish_time: 13}
      ]
    },
    %{
      id: 3,
      bookings: [
        %{id: 6, start_time: 2, finish_time: 7}
      ]
    }
  ]

  test "sorts by start time, run time, then id" do
    assert Leet.AssignCourts.sort_requests(@requests) == [
             %{id: 3, start_time: 0, finish_time: 2},
             %{id: 1, start_time: 0, finish_time: 5},
             %{id: 6, start_time: 2, finish_time: 7},
             %{id: 4, start_time: 3, finish_time: 4},
             %{id: 5, start_time: 5, finish_time: 6},
             %{id: 2, start_time: 7, finish_time: 10},
             %{id: 7, start_time: 8, finish_time: 13}
           ]
  end

  test "assign_courts" do
    assert Leet.AssignCourts.assign_courts(@requests) == @court_bookings
  end

  test "get_unassiged_requests" do
    {assigned, remianing} = {Enum.take(@requests, 2), Enum.drop(@requests, 2)}
    assert Leet.AssignCourts.get_unassiged_requests(assigned, @requests) == remianing
  end

  test "conflicts" do
    [req | rest] = @requests

    assert Leet.AssignCourts.get_conflicting_requests(req.finish_time, rest) == [
             %{id: 3, start_time: 0, finish_time: 2},
             %{id: 4, start_time: 3, finish_time: 4},
             %{id: 5, start_time: 5, finish_time: 6},
             %{id: 6, start_time: 2, finish_time: 7}
           ]
  end
end
