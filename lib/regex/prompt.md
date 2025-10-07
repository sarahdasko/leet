# Challenge: Regex Matcher (DP)

Implement full string matching with pattern features:

- `.` matches any single character
- `*` means “zero or more of the preceding element”

Return `true` if the entire input string matches the entire pattern, else `false`.

This is the canonical DP problem (à la LeetCode #10). It’s not array-centric and really tests state modeling.

## Function Signature

```sh
@spec is_match(String.t(), String.t()) :: boolean
```

## Examples

- `s = "aa"`, `p = "a"` → `false`
- `s = "aa"`, `p = "a*"` → `true` (`a*` can be `“aa”`)
- `s = "ab"`, `p = ".*"` → `true` (`.*` can be any two chars)
- `s = "aab"`, `p = "c*a*b"` → `true` (`c*`→"", `a*`→"aa", then `b`)
- `s = "mississippi"`, `p = "mis*is*p*."` → `false`
