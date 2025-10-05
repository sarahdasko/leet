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

      iex> Leet.AlienAlphabet.order(["car", "cart", "dog", "dot", "zebra"])
      ["c", "d", "z", "g", "t", "a", "r", "o", "e", "b"]

      iex> Leet.AlienAlphabet.order(["cat", "cog", "dog", "dot"])
      ["c", "d", "a", "o", "g", "t"]

      iex> Leet.AlienAlphabet.order(["z", "x", "z"])
      []

      iex> Leet.AlienAlphabet.order([])
      []

      iex> Leet.AlienAlphabet.order(["z"])
      []
  """
  def order([]), do: []
  def order([_]), do: []

  def order(word_list) do
    ordered_letters = get_ordered_letters(word_list)

    if length(ordered_letters) == MapSet.size(MapSet.new(ordered_letters)) do
      remaining_letters =
        word_list
        |> get_all_letters()
        |> Enum.filter(&(Enum.member?(ordered_letters, &1) == false))

      ordered_letters ++ remaining_letters
    else
      []
    end
  end

  @doc """
  Clean the word, so it's always consistent for processing

  ## Examples
      iex> Leet.AlienAlphabet.clean_word("HeLLo   ")
      "hello"

      iex> Leet.AlienAlphabet.clean_word("   WOrlD  ")
      "world"
  """
  def clean_word(word) do
    word
    |> String.downcase()
    |> String.trim()
  end

  def get_ordered_letters(words) do
    words
    |> Enum.map(&clean_word/1)
    |> get_word_pairs()
    |> Enum.map(&word_diff/1)
    |> Enum.filter(fn v -> v != {} end)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.map(fn t -> [elem(t, 1), elem(t, 2)] end)
    |> List.flatten()
    |> Enum.dedup()
  end

  @doc """
  Get all of the letters in the dictionary

  ## Examples
      iex> Leet.AlienAlphabet.get_all_letters(["hello", "world"])
      ["h", "e", "l", "o", "w", "r", "d"]
  """
  def get_all_letters(words) do
    words
    |> Enum.map(&String.graphemes/1)
    |> List.flatten()
    |> Enum.uniq()
  end

  @doc """
  Pair all words as {word_n, word_n+1}

  ## Examples
      iex> Leet.AlienAlphabet.get_word_pairs(["a", "b"])
      [{"a", "b"}]

      iex> Leet.AlienAlphabet.get_word_pairs(["a", "b", "c"])
      [{"a", "b"}, {"b", "c"}]
  """
  def get_word_pairs([w1 | [w2 | []]]), do: [{w1, w2}]

  def get_word_pairs([w1 | [w2 | _r] = rw]) do
    [{w1, w2} | get_word_pairs(rw)]
  end

  @doc """
  Return diff of letters in order of word index and when it happened

  ## Examples
      iex> Leet.AlienAlphabet.word_diff({"wrt", "wrf"})
      {2, "t", "f"}

      iex> Leet.AlienAlphabet.word_diff({"wrf", "er"})
      {0, "w", "e"}

      iex> Leet.AlienAlphabet.word_diff({"apple", "app"})
      {}

      iex> Leet.AlienAlphabet.word_diff({"wr", "wrf"})
      {}

      iex> Leet.AlienAlphabet.word_diff({"wr", "wrfb"})
      {}
  """
  def word_diff({word1, word2}) do
    w1 = String.graphemes(word1)
    w2 = String.graphemes(word2)

    max_len = max(length(w1), length(w2))

    diff_idxs =
      0..(max_len - 1)
      |> Enum.drop_while(fn idx ->
        Enum.at(w1, idx) == Enum.at(w2, idx)
      end)

    if length(diff_idxs) > 0 do
      diff_idx = hd(diff_idxs)
      letter_diff(diff_idx, Enum.at(w1, diff_idx), Enum.at(w2, diff_idx))
    else
      {}
    end
  end

  def letter_diff(_, nil, nil), do: {}
  def letter_diff(_, _, nil), do: {}
  def letter_diff(_, nil, _), do: {}

  def letter_diff(idx, l1, l2) do
    {idx, l1, l2}
  end
end
