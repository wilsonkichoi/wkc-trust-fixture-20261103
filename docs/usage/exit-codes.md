# kv exit codes

Every `kv` command uses these exit codes (SPEC section 1):

- 0: success.
- 1: key not found.
- 2: bad input: a wrong argument count, a bad key, or a bad value.
- 3: conflict.
