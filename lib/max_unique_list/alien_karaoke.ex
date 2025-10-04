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
    {{longest_list, _, _}, _} =
      Enum.reduce(
        song_ids,
        {{[], MapSet.new(), 0}, {[], MapSet.new(), 0}},
        fn id, acc ->
          {longest, current} = acc
          {_, curr_hash, _} = current

          new_current =
            if MapSet.member?(curr_hash, id) do
              pop_back_and_prepend(current, id)
            else
              prepend(current, id)
            end

          {
            get_longest(longest, new_current),
            new_current
          }
        end
      )

    longest_list |> Enum.reverse()
  end

  @doc """
  Get whichever list is the longest

  ## Examples
      iex> Leet.AlienKaraoke.get_longest({[1, 2, 3], MapSet.new([1, 2, 3]), 3}, {[1, 2], MapSet.new([1, 2]), 2})
      {[1, 2, 3], MapSet.new([1, 2, 3]), 3}

      iex> Leet.AlienKaraoke.get_longest({[1, 2], MapSet.new([1, 2]), 2}, {[1,2,3], MapSet.new([1, 2, 3]), 3})
      {[1, 2, 3], MapSet.new([1, 2, 3]), 3}

      iex> Leet.AlienKaraoke.get_longest({[1, 2], MapSet.new([1, 2]), 3}, {[2, 3], MapSet.new([2, 3]), 2})
      {[1, 2], MapSet.new([1, 2]), 3}
  """
  def get_longest({_, _, list1_size} = list1, {_, _, list2_size} = list2) do
    case list1_size >= list2_size do
      true -> list1
      _ -> list2
    end
  end

  @doc """
  Pop back to the id and prepent the id to the list

  ## Examples
      iex> Leet.AlienKaraoke.pop_back_and_prepend({[3, 2, 1], MapSet.new([1, 2, 3]), 3}, 1)
      {[1, 3, 2], MapSet.new([1, 2, 3]), 3}

      iex> Leet.AlienKaraoke.pop_back_and_prepend({[3, 2, 1], MapSet.new([1, 2, 3]), 3}, 2)
      {[2, 3], MapSet.new([2, 3]), 2}
  """
  def pop_back_and_prepend(list, id) do
    list
    |> pop_back(id)
    |> prepend(id)
  end

  @doc """
  Remove all items after and including id from the list

  ## Examples
      iex> Leet.AlienKaraoke.pop_back({[3, 2, 1], MapSet.new([1, 2, 3]), 3}, 1)
      {[3, 2], MapSet.new([2, 3]), 2}

      iex> Leet.AlienKaraoke.pop_back({[3, 2, 1], MapSet.new([1, 2, 3]), 3}, 2)
      {[3], MapSet.new([3]), 1}
  """
  def pop_back({list, hash, len}, id) do
    {keep, rest} = Enum.split_while(list, &(&1 != id))

    {new_hash, new_len} =
      Enum.reduce(rest, {hash, len}, fn x, {h, l} ->
        {
          MapSet.delete(h, x),
          l - 1
        }
      end)

    {keep, new_hash, new_len}
  end

  @doc """
  Append the id to the list

  ## Examples
      iex> Leet.AlienKaraoke.prepend({[2, 1], MapSet.new([2, 1]), 2}, 3)
      {[3, 2, 1], MapSet.new([1, 2, 3]), 3}

      iex> Leet.AlienKaraoke.prepend({[], MapSet.new(), 0}, 1)
      {[1], MapSet.new([1]), 1}
  """
  def prepend({list, hash, len}, id) do
    {[id | list], MapSet.put(hash, id), len + 1}
  end
end
