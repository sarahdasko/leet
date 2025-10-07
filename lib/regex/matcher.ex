defmodule Leet.RegexMatcher do
  @moduledoc """
  Documentation for `Leet.RegexMatcher`.
  """

  @doc """
  Determine if the passed in string matches the pattern.

  ## Examples
      iex> Leet.RegexMatcher.is_match?("aa", "a")
      false

      iex> Leet.RegexMatcher.is_match?("aa", "a*")
      true

      iex> Leet.RegexMatcher.is_match?("ab", ".*")
      true

      iex> Leet.RegexMatcher.is_match?("aab", "c*a*b")
      true

      iex> Leet.RegexMatcher.is_match?("mississippi", "mis*is*p*.")
      false

      iex> Leet.RegexMatcher.is_match?("mississippi", "mis*is*i*p*.")
      true

  """
  @spec is_match?(String.t(), String.t()) :: boolean
  def is_match?("", _ptn), do: false

  def is_match?(str, ptn) do
    case valid_pattern?(ptn) do
      # do thing
      true ->
        str
        |> parse_string()
        |> Enum.reduce(
          {
            true,
            parse_pattern(ptn)
          },
          fn str_char, {matches, rem_ptns} ->
            case rem_ptns do
              # ran out of patterns
              [] ->
                {false, []}

              _ ->
                [curr_ptn | rest_ptns] = rem_ptns

                case {is_letter_pattern_match?(str_char, curr_ptn), curr_ptn, rest_ptns} do
                  {true, _, _} ->
                    {true && matches, rest_ptns}

                  {false, _, _} ->
                    {false, rest_ptns}

                  # more processing
                  {nil, %{multi: true, any_char: true}, []} ->
                    {matches, rem_ptns}

                  {nil, _, _} ->
                    # consume patterns until a match is found (or all are gone)
                    remaining_ptns =
                      rest_ptns
                      |> Enum.drop_while(fn ptn ->
                        match = is_letter_pattern_match?(str_char, ptn)
                        match || match == nil
                      end)

                    {matches, remaining_ptns}
                end
            end
          end
        )
        |> elem(0)

      _ ->
        false
    end
  end

  @doc """
  Determine if the pattern is valid.

  %{char: "a", count: 1}, %{char: "a", multi: true, any_char: false}

  ## Examples
      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 1}, %{char: "a", multi: false})
      true

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 1}, %{char: "b", multi: false})
      false

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 2}, %{char: "a", multi: false})
      false

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 1}, %{char: "a", multi: true})
      true

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 3}, %{char: "a", multi: true})
      true

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 1}, %{char: "b", multi: true})
      nil

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 1}, %{any_char: true, multi: false})
      true

      iex> Leet.RegexMatcher.is_letter_pattern_match?(%{char: "a", count: 1}, %{any_char: true, multi: true})
      nil
  """
  def is_letter_pattern_match?(%{char: sc, count: ctr}, %{char: mc, multi: false}),
    do: sc == mc && ctr == 1

  def is_letter_pattern_match?(%{char: _sc, count: 1}, %{any_char: true, multi: false}),
    do: true

  def is_letter_pattern_match?(%{char: sc, count: _ctr}, %{char: mc, multi: true}) when sc == mc,
    do: true

  def is_letter_pattern_match?(_, _) do
    nil
  end

  @doc """
  Determine if the pattern is valid.

  ## Examples
      iex> Leet.RegexMatcher.valid_pattern?("a")
      true

      iex> Leet.RegexMatcher.valid_pattern?("a*")
      true

      iex> Leet.RegexMatcher.valid_pattern?(".*")
      true

      iex> Leet.RegexMatcher.valid_pattern?("c*a*b")
      true

      iex> Leet.RegexMatcher.valid_pattern?("*a*")
      false

      iex> Leet.RegexMatcher.valid_pattern?("a**b*")
      false

      iex> Leet.RegexMatcher.valid_pattern?("")
      false

  """
  def valid_pattern?(ptn) do
    cond do
      String.length(ptn) == 0 -> false
      String.contains?(ptn, "**") -> false
      String.starts_with?(ptn, "*") -> false
      true -> true
    end
  end

  @doc """
  Parse string into matchable chunks.

  ## Examples
      iex> Leet.RegexMatcher.parse_string("a")
      [%{char: "a", count: 1}]

      iex> Leet.RegexMatcher.parse_string("aa")
      [%{char: "a", count: 2}]

      iex> Leet.RegexMatcher.parse_string("aab")
      [
        %{char: "a", count: 2},
        %{char: "b", count: 1},
      ]

      iex> Leet.RegexMatcher.parse_string("mississippi")
      [
        %{char: "m", count: 1},
        %{char: "i", count: 1},
        %{char: "s", count: 2},
        %{char: "i", count: 1},
        %{char: "s", count: 2},
        %{char: "i", count: 1},
        %{char: "p", count: 2},
        %{char: "i", count: 1}
      ]

  """
  def parse_string(str) do
    str
    |> String.splitter("", trim: true)
    |> Enum.reduce(
      [],
      &parse_string_letter/2
      # fn ltr, acc -> parse_string_letter(ltr, acc) end
    )
    |> Enum.reverse()
  end

  @doc """
  Accumulate the string's letters into matchable chunks.

  ## Examples
      iex> Leet.RegexMatcher.parse_string_letter("a", [])
      [%{char: "a", count: 1}]

      iex> Leet.RegexMatcher.parse_string_letter("a", [%{char: "a", count: 1}])
      [%{char: "a", count: 2}]

      iex> Leet.RegexMatcher.parse_string_letter("b", [%{char: "a", count: 2}])
      [
        %{char: "b", count: 1},
        %{char: "a", count: 2}
      ]
  """
  def parse_string_letter(ltr, []), do: [%{char: ltr, count: 1}]

  def parse_string_letter(ltr, [%{char: curr_ltr, count: curr_ctr} | rest] = _acc)
      when ltr == curr_ltr do
    [%{char: curr_ltr, count: curr_ctr + 1} | rest]
  end

  def parse_string_letter(ltr, acc) do
    [%{char: ltr, count: 1} | acc]
  end

  @doc """
  Parse pattern into parsable chunks.

  ## Examples
      iex> Leet.RegexMatcher.parse_pattern("a")
      [%{char: "a", multi: false}]

      iex> Leet.RegexMatcher.parse_pattern("a*")
      [%{char: "a", multi: true}]

      iex> Leet.RegexMatcher.parse_pattern(".*")
      [%{any_char: true, multi: true}]

      iex> Leet.RegexMatcher.parse_pattern("c*a*.")
      [
        %{char: "c", multi: true},
        %{char: "a", multi: true},
        %{any_char: true, multi: false}
      ]

      iex> Leet.RegexMatcher.parse_pattern("c*a*.b")
      [
        %{char: "c", multi: true},
        %{char: "a", multi: true},
        %{any_char: true, multi: false},
        %{char: "b", multi: false}
      ]

  """
  def parse_pattern(ptn) do
    ptn
    |> String.splitter("", trim: true)
    |> Stream.chunk_every(2, 1)
    |> Enum.map(fn
      [a] -> parse_pattern_chunk(a, nil)
      [a, b] -> parse_pattern_chunk(a, b)
    end)
    |> List.flatten()
  end

  @doc """
  Output parseable pattern chunk

  ## Examples
      iex> Leet.RegexMatcher.parse_pattern_chunk("a", "*")
      [%{char: "a", multi: true}]

      iex> Leet.RegexMatcher.parse_pattern_chunk(".", "*")
      [%{any_char: true, multi: true}]

      iex> Leet.RegexMatcher.parse_pattern_chunk("a", "b")
      [%{char: "a", multi: false}]

      iex> Leet.RegexMatcher.parse_pattern_chunk("a", ".")
      [%{char: "a", multi: false}]

      iex> Leet.RegexMatcher.parse_pattern_chunk(".", "a")
      [%{any_char: true, multi: false}]

      iex> Leet.RegexMatcher.parse_pattern_chunk("*", "a")
      []

      iex> Leet.RegexMatcher.parse_pattern_chunk("a", nil)
      [%{char: "a", multi: false}]

      iex> Leet.RegexMatcher.parse_pattern_chunk(".", nil)
      [%{any_char: true, multi: false}]

      iex> Leet.RegexMatcher.parse_pattern_chunk("*", nil)
      []

  """
  def parse_pattern_chunk("*", _letter2), do: []
  def parse_pattern_chunk(".", letter2), do: [%{multi: letter2 == "*", any_char: true}]

  def parse_pattern_chunk(letter1, letter2),
    do: [%{char: letter1, multi: letter2 == "*"}]
end
