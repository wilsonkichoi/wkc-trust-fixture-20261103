# kv keys and values

A key matches `^[A-Za-z0-9_.-]{1,64}$` (SPEC 2.2). A value is any string without a tab or a newline,
stored and returned verbatim. A bad key or value exits 2.

## Example

`user.name` and `build-42` are keys; `a b` is not.
