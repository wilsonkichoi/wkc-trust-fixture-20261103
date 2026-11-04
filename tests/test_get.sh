. "$(dirname "$0")/lib.sh"

TAB=$(printf '\t')
printf 'alpha%sone\nbeta%sa b  c\n' "$TAB" "$TAB" > "$KV_FILE"

[ "$("$KV" get alpha)" = "one" ] || fail "get alpha did not print its value"
[ "$("$KV" get beta)" = "a b  c" ] || fail "get beta did not print its value verbatim"
[ "$("$KV" get alpha | wc -l | tr -d ' ')" = "1" ] || fail "get did not print exactly one line"

out=$("$KV" get missing 2>/dev/null)
[ -z "$out" ] || fail "missing key printed to stdout"
expect_exit 1 "$KV" get missing
expect_exit 1 "$KV" get alph

expect_exit 2 "$KV" get 'bad key'
expect_exit 2 "$KV" get 'a/b'
expect_exit 2 "$KV" get ''
expect_exit 2 "$KV" get
expect_exit 2 "$KV" get alpha beta
expect_exit 2 "$KV" get "$(printf 'a%.0s' $(seq 65))"

rm -f "$KV_FILE"
expect_exit 1 "$KV" get alpha
"$KV" help | grep -q '^get' || fail "help does not list get"
