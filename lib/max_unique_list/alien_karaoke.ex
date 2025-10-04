defmodule Leet.AlienKaraoke do
  @moduledoc """
  Documentation for `Leet`.
  """

  @doc """
  Find the longest, non-repeating list of song ids

  ## Examples
      iex> Leet.AlienKaraoke.find_best_list([5, 1, 3, 5, 2, 3, 4, 1])
      [5, 2, 3, 4, 1]

      iex> Leet.AlienKaraoke.find_best_list([1, 2, 3, 4, 5])
      [1, 2, 3, 4, 5]

      iex> Leet.AlienKaraoke.find_best_list([2, 2, 2])
      [2]

      iex> Leet.AlienKaraoke.find_best_list([1, 2, 3, 4, 1, 2])
      [1, 2, 3, 4]

      iex> Leet.AlienKaraoke.find_best_list([9, 9, 1, 2, 3, 4, 1])
      [9, 1, 2, 3, 4]

      iex> Leet.AlienKaraoke.find_best_list([1, 2, 3, 4, 4, 3, 2, 1])
      [1, 2, 3, 4]
  """
  def find_best_list(song_ids) do
    {{longest_list, _}, _} =
      Enum.reduce(
        song_ids,
        {{[], 0}, {[], MapSet.new(), 0}},
        fn id, acc ->
          {longest, current} = acc
          {curr_list, hash_ids, curr_size} = current

          new_current =
            if MapSet.member?(hash_ids, id) do
              new_curr = pop_back_and_prepend(curr_list, id)
              new_hash = MapSet.new(new_curr)

              {
                new_curr,
                new_hash,
                MapSet.size(new_hash)
              }
            else
              {
                prepend(curr_list, id),
                MapSet.put(hash_ids, id),
                curr_size + 1
              }
            end

          {curr_list, _hash_ids, curr_size} = new_current

          {
            get_longest(longest, {curr_list, curr_size}),
            new_current
          }
        end
      )

    longest_list |> Enum.reverse()
  end

  @doc """
  Get whichever list is the longest

  ## Examples
      iex> Leet.AlienKaraoke.get_longest({[1,2,3], 3}, {[1,2], 2})
      {[1,2,3], 3}

      iex> Leet.AlienKaraoke.get_longest({[1,2], 2}, {[1,2,3], 3})
      {[1,2,3], 3}

      iex> Leet.AlienKaraoke.get_longest({[1,2], 3}, {[2,3], 2})
      {[1,2], 3}
  """
  def get_longest({_, list1_size} = list1, {_, list2_size} = list2) do
    case list1_size >= list2_size do
      true -> list1
      _ -> list2
    end
  end

  @doc """
  Pop back to the id and prepent the id to the list

  ## Examples
      iex> Leet.AlienKaraoke.pop_back_and_prepend([3,2,1], 1)
      [1,3,2]

      iex> Leet.AlienKaraoke.pop_back_and_prepend([3,2,1], 2)
      [2,3]
  """
  def pop_back_and_prepend(list, id) do
    list
    |> pop_back(id)
    |> prepend(id)
  end

  @doc """
  Remove all items after and including id from the list

  ## Examples
      iex> Leet.AlienKaraoke.pop_back([3,2,1], 1)
      [3,2]

      iex> Leet.AlienKaraoke.pop_back([3,2,1], 2)
      [3]
  """
  def pop_back(list, id) do
    list
    |> Enum.reverse()
    |> Enum.drop_while(&(&1 != id))
    |> case do
      [] -> list
      [_ | rest] -> Enum.reverse(rest)
    end
  end

  @doc """
  Append the id to the list

  ## Examples
      iex> Leet.AlienKaraoke.prepend([2, 1], 3)
      [3,2,1]

      iex> Leet.AlienKaraoke.prepend([], 1)
      [1]
  """
  def prepend(list, id) do
    [id | list]
  end
end
