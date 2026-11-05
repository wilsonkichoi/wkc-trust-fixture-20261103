. "$(dirname "$0")/lib.sh"

TAB=$(printf '\t')
printf 'alpha%sone\nbeta%stwo words\nempty%s\n' "$TAB" "$TAB" "$TAB" >"$KV_FILE"

out=$("$KV" get alpha)
[ "$out" = "one" ] || fail "get alpha printed '$out'"
"$KV" get beta | od -c | grep -q 'w   o   r   d   s  \\n' || fail "get beta lacks trailing newline"
[ "$("$KV" get beta)" = "two words" ] || fail "get beta wrong"
expect_exit 0 "$KV" get empty

out=$("$KV" get missing 2>/dev/null)
[ -z "$out" ] || fail "missing key printed to stdout"
expect_exit 1 "$KV" get missing
expect_exit 2 "$KV" get 'bad key'
expect_exit 2 "$KV" get 'a/b'
expect_exit 2 "$KV" get "$(printf 'alpha\nx')"
expect_exit 2 "$KV" get ""
expect_exit 2 "$KV" get "$(printf '%065d' 0)"
expect_exit 2 "$KV" get
expect_exit 2 "$KV" get a b

rm -f "$KV_FILE"
expect_exit 1 "$KV" get alpha
"$KV" help | grep -q '^get' || fail "help does not list get"
