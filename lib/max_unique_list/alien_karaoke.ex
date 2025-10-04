defmodule Leet.AlienKaraokeV1 do
  @moduledoc """
  Documentation for `AlienKaraoke`.

  this run sin O(n^2)
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

  """
  def find_best_list(song_ids) do
    {longest_list, curr_list} =
      Enum.reduce(
        song_ids,
        {[], []},
        fn id, acc ->
          {longest_list, curr_list} = acc

          if id in curr_list do
            {
              get_longest(longest_list, curr_list),
              pop_and_append(curr_list, id)
            }
          else
            {
              longest_list,
              append(curr_list, id)
            }
          end
        end
      )

    get_longest(longest_list, curr_list)
  end

  @doc """
  Get whichever list is the longest

  ## Examples
      iex> Leet.AlienKaraoke.get_longest([1,2,3], [1,2])
      [1,2,3]

      iex> Leet.AlienKaraoke.get_longest([1,2], [1,2,3])
      [1,2,3]

      iex> Leet.AlienKaraoke.get_longest([1,2], [1,2])
      [1,2]

  """
  def get_longest(list1, list2) do
    Enum.max_by([list1, list2], &length/1)
  end

  @doc """
  Pop to the id and append the id to the end

  ## Examples
      iex> Leet.AlienKaraoke.pop_and_append([1,2,3], 1)
      [2,3,1]

      iex> Leet.AlienKaraoke.pop_and_append([1,2,3], 2)
      [3,2]
  """
  def pop_and_append(list, id) do
    idx = Enum.find_index(list, &(&1 == id))
    {_, list} = Enum.split(list, idx + 1)
    append(list, id)
  end

  @doc """
  Append the id to the list

  ## Examples
      iex> Leet.AlienKaraoke.append([1,2], 3)
      [1,2,3]

      iex> Leet.AlienKaraoke.append([], 1)
      [1]
  """
  def append(list, id) do
    list ++ [id]
  end
end
