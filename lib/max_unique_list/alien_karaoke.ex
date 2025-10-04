defmodule Leet.AlienKaraoke do
  @moduledoc """
  Documentation for `AlienKaraoke`.
  """

  @doc """
  Find the longest, non-repeating list of song ids

  ## Examples
      # iex> Leet.AlienKaraoke.find_best_list([5, 1, 3, 5, 2, 3, 4, 1])
      # [5, 2, 3, 4, 1]

      # iex> Leet.AlienKaraoke.find_best_list([1, 2, 3, 4, 5])
      # [1, 2, 3, 4, 5]

      # iex> Leet.AlienKaraoke.find_best_list([2, 2, 2])
      # [2]

      # iex> Leet.AlienKaraoke.find_best_list([1, 2, 3, 4, 1, 2])
      # [1, 2, 3, 4]

      # iex> Leet.AlienKaraoke.find_best_list([9, 9, 1, 2, 3, 4, 1])
      # [9, 1, 2, 3, 4]

      iex> Leet.AlienKaraoke.find_best_list([1, 2, 3, 4, 4, 3, 2, 1])
      [1, 2, 3, 4]
  """
  def find_best_list([]), do: []

  def find_best_list(song_ids) do
    {best_start_idx, best_end_idx, _, _} =
      song_ids
      |> Enum.with_index()
      |> Enum.reduce(
        {0, 0, 0, %{}},
        fn curr_song, acc ->
          {song_id, idx} = curr_song
          {best_start_idx, best_end_idx, curr_start_idx, curr_song_list} = acc

          prev_song_idx = Map.get(curr_song_list, song_id, -1)

          new_curr_start_idx = max(curr_start_idx, prev_song_idx + 1)

          {new_best_start_idx, new_best_end_idx} =
            get_longest({best_start_idx, best_end_idx}, {new_curr_start_idx, idx})

          {
            new_best_start_idx,
            new_best_end_idx,
            new_curr_start_idx,
            Map.put(curr_song_list, song_id, idx)
          }
        end
      )

    len = best_end_idx - best_start_idx + 1
    Enum.slice(song_ids, best_start_idx, len)
  end

  @doc """
  Get the tuple with the largest diff between the two values

  ## Examples
      iex> Leet.AlienKaraoke.get_longest({0, 1}, {0, 2})
      {0, 2}

      iex> Leet.AlienKaraoke.get_longest({0, 3}, {2, 4})
      {0, 3}
  """
  def get_longest({start_idx1, end_idx1} = l1, {start_idx2, end_idx2} = l2) do
    if end_idx1 - start_idx1 >= end_idx2 - start_idx2 do
      l1
    else
      l2
    end
  end
end
