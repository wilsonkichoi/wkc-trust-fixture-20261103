. "$(dirname "$0")/lib.sh"

TAB=$(printf '\t')

# a new key
expect_exit 0 "$KV" set alpha one
[ "$(cat "$KV_FILE")" = "alpha${TAB}one" ] || fail "new key not stored"

# an overwrite leaves one line for the key
expect_exit 0 "$KV" set beta two
expect_exit 0 "$KV" set alpha uno
[ "$(grep -c "^alpha${TAB}" "$KV_FILE")" -eq 1 ] || fail "overwrite left more than one line"
grep -q "^alpha${TAB}uno$" "$KV_FILE" || fail "overwrite did not replace the value"
grep -q "^beta${TAB}two$" "$KV_FILE" || fail "overwrite lost another key"

# a bad key
expect_exit 2 "$KV" set 'bad key' v
expect_exit 2 "$KV" set '' v
expect_exit 2 "$KV" set "$(printf 'k%.0s' $(seq 65))" v

# a value with a tab or a newline
expect_exit 2 "$KV" set k "a${TAB}b"
expect_exit 2 "$KV" set k "$(printf 'a\nb')"

# wrong argument count
expect_exit 2 "$KV" set
expect_exit 2 "$KV" set onlykey
expect_exit 2 "$KV" set k v extra

# values are stored verbatim, including a credential-shaped string.
# The token is built at run time so no literal one is committed.
token="ghp_$(printf 'aB3%.0s' $(seq 12))"
[ ${#token} -eq 40 ] || fail "test token has the wrong length"
expect_exit 0 "$KV" set cred "$token"
grep -qxF "cred${TAB}${token}" "$KV_FILE" || fail "token-shaped value not stored unchanged"

# a backslash is stored as is
expect_exit 0 "$KV" set bs 'a\nb'
grep -qxF "bs${TAB}"'a\nb' "$KV_FILE" || fail "backslash value changed"

# no temporary file is left behind
[ "$(ls "$TMP" | wc -l)" -eq 1 ] || fail "temporary file left in $TMP"
