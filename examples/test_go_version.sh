#! /bin/sh
# file: examples/test_go_version

EXPECTED_GO_VERSION='go version go1.15.6 linux/amd64'
GO_INSTALL_LOCATION='/usr/local/go'

testGoInstalledVersion() {
  go_version=$($GO_INSTALL_LOCATION/bin/go version)
  assertEquals 'Golang version incorrect' "$EXPECTED_GO_VERSION" "$go_version"
}

testGoUninstallNoVersion() {
  $(bash uninstall.sh)
  set -e

  go_version=$($GO_INSTALL_LOCATION/bin/go version)
  assertFalse "go cmd should not be installed" $?
}

. shunit2
