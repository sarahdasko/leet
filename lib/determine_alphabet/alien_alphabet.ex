defmodule Leet.AlienAlphabet do
  @moduledoc """
  Documentation for `Leet`.
  """

  @doc """
  Return the alphabet's order

  ## Examples
      iex> Leet.AlienAlphabet.order(["wrt", "wrf", "er", "ett", "rftt"])
      ["w", "e", "r", "t", "f"]

      iex> Leet.AlienAlphabet.order(["z", "x"])
      ["z", "x"]

      iex> Leet.AlienAlphabet.order(["z", "x", "z"])
      []

      iex> Leet.AlienAlphabet.order(["car", "cart", "dog", "dot", "zebra"])
      ["c", "g", "t", "d", "z", "a", "o", "r"]
  """
  def order(word_list) do
    word_count = length(word_list)

    words =
      word_list
      |> IO.inspect(label: "words")
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.downcase/1)
      |> Enum.map(&String.graphemes/1)

    alpha =
      0..(word_count - 2)
      |> Enum.map(fn idx ->
        word_diff(Enum.at(words, idx), Enum.at(words, idx + 1))
      end)
      |> IO.inspect(label: "word_diff")
      |> Enum.sort_by(&elem(&1, 1))
      |> Enum.map(&elem(&1, 0))
      |> Enum.reduce([], fn lo, acc -> acc ++ lo end)
      |> Enum.dedup()

    if length(alpha) == MapSet.size(MapSet.new(alpha)) do
      alpha
    else
      []
    end
    |> IO.inspect(label: "alpha")
  end

  @doc """
  Return diff of letters in order of word index and when it happened

  ## Examples

      iex> Leet.AlienAlphabet.word_diff(["w", "r", "t"], ["w", "r", "f"])
      {["t", "f"], 2}

      iex> Leet.AlienAlphabet.word_diff(["w", "r", "f"], ["e", "r"])
      {["w", "e"], 0}

      iex> Leet.AlienAlphabet.word_diff(["w", "r"], ["w", "r", "f"])
      {["r", "f"], 2}

      iex> Leet.AlienAlphabet.word_diff(["w", "r"], ["w", "r", "f", "b"])
      {["r", "f", "b"], 2}
  """
  def word_diff(word1, word2) do
    len1 = length(word1)
    len2 = length(word2)
    min_len = min(len1, len2)

    diff_idxs =
      0..(min_len - 1)
      |> Enum.drop_while(fn idx ->
        is_same_letter?(word1, word2, idx)
      end)

    cond do
      length(diff_idxs) > 0 ->
        diff_idx = hd(diff_idxs)
        {[Enum.at(word1, diff_idx, ""), Enum.at(word2, diff_idx, "")], diff_idx}

      len1 == len2 ->
        # no differences...
        []

      true ->
        max_len = max(len1, len2)
        {[Enum.at(word1, min_len - 1, "") | Enum.slice(word2, min_len..(max_len - 1))], min_len}
    end
  end

  @doc """
  Return if the letter at the index in both words is the same

  ## Examples

      iex> Leet.AlienAlphabet.is_same_letter?(["a"], ["a"], 0)
      true

      iex> Leet.AlienAlphabet.is_same_letter?(["a", "b"], ["a", "b"], 1)
      true

      iex> Leet.AlienAlphabet.is_same_letter?(["a"], ["b"], 0)
      false

      iex> Leet.AlienAlphabet.is_same_letter?(["a", "a"], ["a", "b"], 1)
      false

      iex> Leet.AlienAlphabet.is_same_letter?(["a"], ["a", "b"], 1)
      false

      iex> Leet.AlienAlphabet.is_same_letter?(["a"], ["a", "b"], 3)
      nil
  """
  def is_same_letter?(word1, word2, index) do
    case {Enum.at(word1, index, ""), Enum.at(word2, index, "")} do
      {"", ""} -> nil
      {"", _} -> false
      {_, ""} -> false
      {l1, l2} -> l1 == l2
    end
  end
end
