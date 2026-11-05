. "$(dirname "$0")/lib.sh"

TAB=$(printf '\t')

expect_exit 0 "$KV" set a 1
[ "$(cat "$KV_FILE")" = "a${TAB}1" ] || fail "new key not stored"

expect_exit 0 "$KV" set a 2
[ "$(grep -c '^a'"$TAB" "$KV_FILE")" -eq 1 ] || fail "overwrite left more than one line"
[ "$(cat "$KV_FILE")" = "a${TAB}2" ] || fail "overwrite did not replace the value"

expect_exit 0 "$KV" set b 3
[ "$(wc -l <"$KV_FILE" | tr -d ' ')" -eq 2 ] || fail "second key not added"

expect_exit 2 "$KV" set 'bad key' 1
expect_exit 2 "$KV" set '' 1
expect_exit 2 "$KV" set "$(printf 'k%.0s' $(seq 1 65))" 1
expect_exit 2 "$KV" set k "a${TAB}b"
expect_exit 2 "$KV" set k
expect_exit 2 "$KV" set k v extra
expect_exit 2 "$KV" set

# Values are stored verbatim, including strings shaped like credentials.
tok="ghp_$(printf 'A1b2C3%.0s' 1 2 3 4 5 6)"
expect_exit 0 "$KV" set tok "$tok"
grep -qF "tok${TAB}${tok}" "$KV_FILE" || fail "token-shaped value was changed"

"$KV" help | grep -q '^set' || fail "help does not list set"
