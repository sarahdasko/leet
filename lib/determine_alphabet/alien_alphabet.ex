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
      ["c", "d", "z", "g", "t", "a", "o", "e", "r", "b"]

      iex> Leet.AlienAlphabet.order(["cat", "cog", "dog", "dot"])
      ["c", "d", "a", "o", "g", "t"]
  """
  def order(word_list) do
    words =
      clean_words(word_list)

    alpha =
      words
      |> graph_letters()
      |> get_edges()
      |> unpack_edges()

    if length(alpha) == MapSet.size(MapSet.new(alpha)), do: alpha, else: []
  end

  @doc """
  Ensure all words are "same"

  ## Examples
      iex> Leet.AlienAlphabet.clean_words(["WRt  "])
      ["wrt"]

      iex> Leet.AlienAlphabet.clean_words(["z", "X"])
      ["z", "x"]
  """
  def clean_words(words) do
    words
    |> Enum.map(&String.downcase/1)
    |> Enum.map(&String.trim/1)
  end

  @doc """
  Graph letters at the level requested

  ## Examples
      iex> Leet.AlienAlphabet.graph_letters(["z", "x"], 0)
      [
        {"z", []},
        {"x", []}
      ]

      iex> Leet.AlienAlphabet.graph_letters(["cat", "cog", "dog", "dot"], 0)
      [
        {
          "c",
          [
            {
              "a",
              [
                {"t", []}
              ]
            },
            {
              "o",
              [
                {"g", []}
              ]
            }
          ]
        },
        {
          "d",
          [
            {
              "o",
              [
                {"g", []},
                {"t", []}
              ]
            }
          ]
        }
      ]
  """
  def graph_letters(words, index \\ 0) do
    words
    |> Enum.map(&String.at(&1, index))
    |> Enum.dedup()
    |> Enum.map(fn letter ->
      # get child letters
      children =
        words
        |> Enum.filter(&(String.at(&1, index) == letter && String.length(&1) > index + 1))
        |> graph_letters(index + 1)

      {letter, children}
    end)
  end

  @doc """
  Graph letters at the level requested

  ## Examples
      iex> Leet.AlienAlphabet.get_edges([{"c", [{"a", [{"t", []}]}, {"o", [{"g", []}]}]}, {"d", [{"o", [{"g", []}, {"t", []}]}]}])
      [
        {0, ["c", "d"]},
        {1, ["a", "o"]},
        {2, ["t"]},
        {2, ["g"]},
        {1, ["o"]},
        {2, ["g", "t"]}
      ]

      iex> Leet.AlienAlphabet.get_edges([{"a", [{"t", []}]}, {"o", [{"g", []}]}], 1)
      [{1, ["a", "o"]}, {2, ["t"]}, {2, ["g"]}]

      iex> Leet.AlienAlphabet.get_edges([{"t", []}], 2)
      [{2, ["t"]}]
  """
  def get_edges(graph, level \\ 0) do
    current_level =
      {
        level,
        Enum.map(graph, &elem(&1, 0))
      }

    next_level =
      graph
      |> Enum.map(&elem(&1, 1))
      |> Enum.map(&get_edges(&1, level + 1))

    ([current_level] ++ next_level)
    |> List.flatten()
    |> Enum.filter(fn {_, l} -> length(l) > 0 end)
  end

  @doc """
  Trace the edges and accumulate letters in the order seen

  ## Examples
      iex> Leet.AlienAlphabet.unpack_edges(
      ...>  [
      ...>    {0, ["c", "d"]},
      ...>    {1, ["a", "o"]},
      ...>    {2, ["t"]},
      ...>    {2, ["g"]},
      ...>    {1, ["o"]},
      ...>    {2, ["g", "t"]}
      ...>  ]
      ...> )
      ["c", "d", "a", "o", "g", "t"]

      iex> Leet.AlienAlphabet.unpack_edges([{1, ["a", "o"]}, {2, ["t"]}, {2, ["g"]}])
      ["a", "o", "t", "g"]

      iex> Leet.AlienAlphabet.unpack_edges([{2, ["t"]}])
      ["t"]
  """
  def unpack_edges(edges) do
    edges
    |> Enum.sort_by(&{-length(elem(&1, 1)), elem(&1, 0)})
    |> Enum.map(&elem(&1, 1))
    |> Enum.reduce(
      [],
      fn edge, acc ->
        edge_size = length(edge)
        letters_seen = MapSet.new(acc)

        cond do
          edge_size > 1 ->
            acc ++ edge

          hd(edge) in letters_seen ->
            acc

          true ->
            acc ++ edge
        end
      end
    )
    |> List.flatten()
    |> Enum.dedup()
  end
end
