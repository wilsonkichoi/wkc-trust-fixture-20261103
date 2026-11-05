# kv store file

The store is the file named by `KV_FILE`, default `$HOME/.kv` (SPEC 2.1). Each record is one line,
`<key><TAB><value>`, and a key appears at most once. Commands create the file when it is missing,
and rewrite it through a temporary file in the same directory followed by `mv`.

## Example

```
$ KV_FILE=/tmp/demo.kv kv help
```
