#!/bin/sh
# Tests for kv get (SPEC 3.2). The store is written directly, not through kv set.
. "$(dirname "$0")/lib.sh"

TAB=$(printf '\t')

# Missing store file: exit 1.
rm -f "$KV_FILE"
expect_exit 1 "$KV" get a

printf 'a%sone\nb.c-d_e%shello world\nempty%s\n' "$TAB" "$TAB" "$TAB" > "$KV_FILE"

# Existing key prints its value and a newline.
out=$("$KV" get a) || fail "get a failed"
[ "$out" = "one" ] || fail "get a printed '$out'"
"$KV" get a | od -c | grep -q '\\n' || fail "get a printed no newline"
[ "$("$KV" get b.c-d_e)" = "hello world" ] || fail "get with spaces and punctuation key"
[ -z "$("$KV" get empty)" ] || fail "get empty printed a value"
expect_exit 0 "$KV" get empty

# Missing key: exit 1, nothing on stdout.
out=$("$KV" get nope 2>/dev/null)
[ $? -eq 1 ] || fail "missing key did not exit 1"
[ -z "$out" ] || fail "missing key printed to stdout"

# A key is matched whole, not as a prefix.
expect_exit 1 "$KV" get on

# Bad key and wrong argument count: exit 2.
expect_exit 2 "$KV" get 'bad key'
expect_exit 2 "$KV" get 'a/b'
expect_exit 2 "$KV" get ''
expect_exit 2 "$KV" get xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
expect_exit 2 "$KV" get
expect_exit 2 "$KV" get a b

# Bad key wins over a missing store file.
rm -f "$KV_FILE"
expect_exit 2 "$KV" get 'bad key'

# Help lists get.
"$KV" help | grep -q '^get ' || fail "help does not list get"
echo "test_get ok"
