. "$(dirname "$0")/lib.sh"

TAB=$(printf '\t')

# a new key
expect_exit 0 "$KV" set alpha one
[ "$(cat "$KV_FILE")" = "alpha${TAB}one" ] || fail "new key not stored"

# an overwrite leaves one line for the key
"$KV" set beta two
"$KV" set alpha uno
[ "$(grep -c "^alpha${TAB}" "$KV_FILE")" -eq 1 ] || fail "overwrite left more than one alpha line"
grep -q "^alpha${TAB}uno$" "$KV_FILE" || fail "overwrite did not replace the value"
grep -q "^beta${TAB}two$" "$KV_FILE" || fail "overwrite lost another key"

# bad key
expect_exit 2 "$KV" set 'bad key' v
expect_exit 2 "$KV" set '' v
expect_exit 2 "$KV" set "$(printf 'k%.0s' $(seq 1 65))" v

# value with a tab
expect_exit 2 "$KV" set gamma "a${TAB}b"
! grep -q '^gamma' "$KV_FILE" || fail "bad value was stored"

# wrong argument count
expect_exit 2 "$KV" set
expect_exit 2 "$KV" set onlykey
expect_exit 2 "$KV" set a b c

# values are verbatim, including a string shaped like a GitHub token.
# Built at run time so that no token-shaped literal sits in the source.
tok="ghp_$(printf 'aB3%.0s' $(seq 1 12))"
[ ${#tok} -eq 40 ] || fail "test token has the wrong length"
"$KV" set secret "$tok"
grep -qxF "secret${TAB}${tok}" "$KV_FILE" || fail "token-shaped value not stored verbatim"

# no temporary files are left in the store directory
[ "$(ls "$TMP" | wc -l)" -eq 1 ] || fail "temporary file left behind"
