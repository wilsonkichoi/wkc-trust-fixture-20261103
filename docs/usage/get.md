# kv get

`kv get <key>` prints the value stored for `<key>`, followed by a newline (SPEC 3.2).

## Example

```
$ kv set color blue
$ kv get color
blue
```

## Exit codes

- 0: the key exists and its value was printed.
- 1: the key is not in the store.
- 2: bad input, such as a wrong argument count or a key that does not match `^[A-Za-z0-9_.-]{1,64}$`.
