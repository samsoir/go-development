#! /bin/sh
# file: examples/test_go_version

EXPECTED_GO_VERSION='go version go1.15.2 linux/amd64'

testGoVersion() {
  go_version=$(/usr/local/go/bin/go version)
  assertEquals 'Go versions did not match' "$EXPECTED_GO_VERSION" "$go_version"
}

. shunit2
