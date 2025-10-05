# Challenge: Alien Dictionary Sort

An alien language uses the same letters as English, but in a different order.
You’re given a list of words sorted lexicographically according to the alien language’s rules.

## Task
Figure out the order of characters in the alien alphabet. If there are multiple valid orders, return any. If no valid order exists, return an empty list.

## Input
`words :: [String.t()]` (1 ≤ length ≤ 1000, word length ≤ 100).
Guaranteed all lowercase a–z.

## Output
A list of characters (strings of length 1) in a valid alien order, or [].

## Examples
```sh
iex> Leet.AlienDictionary.order(["wrt", "wrf", "er", "ett", "rftt"])
["w", "t", "f", "e", "r"]
```
