#!/bin/bash

set -o errexit
set -o nounset

GO_VERSION='1.15.6'
GO_TMP_DIR='/tmp'
GO_ARCH='amd64'
GO_OS='linux'
GO_VERSION_CHECKSUM='3918e6cc85e7eaaa6f859f1bdbaac772e7a825b0eb423c63d3ae68b21f84b844'
GO_FILENAME="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"
GO_URL="https://dl.google.com/go/${GO_FILENAME}"
GO_PATH='/usr/local'

echo_stderr() {
  (>&2 echo $@)
}

run_as_root() {
  if [ "$UID" -ne 0 ]
  then
    sudo "$@"
  else
    "$@"
  fi
  return $?
}

verify_checksum256() {
  checksum=$1
  file=$2

  computed=($(sha256sum $file))

  if [ "$checksum" = "${computed[0]}" ]
  then
    return 0
  else
    return 1
  fi
}

go_version_installed() {
  if [ "go$1" != "$( gv=($(command -v go &> /dev/null && go version)); echo "${gv[2]-}" )" ]
  then
    return 1
  else
    return 0 
  fi
}

remote_file_to_target() {
  if [ -f $2 ]
  then
    echo "Golang binary $2 found!"
    echo "If this is an issue, then remove $2 and re-run"
    return 0
  fi
  wget -O $2 $1
}

extract_go_package_to_target() {
  run_as_root tar -C $2 -xzf $1
  if [ "$?" -eq 0 ]
  then
    run_as_root chown --recursive "root:root" "$GO_PATH/go"
  fi
}

setup_go_environment() {
  # this assumes zsh for now
  echo "" >> ~/.zshrc
  echo "# Golang configuration -- created by golang install.sh" >> ~/.zshrc
  echo "export GOROOT=/usr/local/go" >> ~/.zshrc
  echo "export GOPATH=\$HOME/go" >> ~/.zshrc
  echo "export PATH=\$PATH:\$GOROOT/bin" >> ~/.zshrc

}

remove_temporary_files() {
  if [ -f $1 ]
  then
    rm $1
  fi
}

# 1. Check go version
if go_version_installed $GO_VERSION
then
  echo "Go version found"
  exit 1
fi

# 2. Download and verify Golang binary tarball
if remote_file_to_target $GO_URL "$GO_TMP_DIR/$GO_FILENAME"
then
  if verify_checksum256 "${GO_VERSION_CHECKSUM}" "$GO_TMP_DIR/$GO_FILENAME"
  then
    echo "Download completed!"
    echo "Checksum verified: $GO_VERSION_CHECKSUM"
  else
    echo_stderr "Checksum verfication failed!"
    exit 2
  fi
else
  echo_stderr "Download failed!"
  exit 3
fi

# 3. Extract tarball to usr/local
extract_go_package_to_target "$GO_TMP_DIR/$GO_FILENAME" "$GO_PATH"
if [ "$?" -eq 0 ]
then
  echo "Installed Golang package $GO_TMP_DIR/$GO_FILENAME to $GO_PATH/go"
else
  echo_stderr "Unable to extract file to $2. Exiting..."
  exit 4
fi

# 4. Setup environment
echo "Setting up .zshrc with GOROOT, GOPATH and adding GOROOT/bin to PATH"
setup_go_environment
echo "Environment configured. Run source ~/.zshrc to load new configuration"

# 5. Clean up
remove_temporary_files "$GO_TMP_DIR/$GO_FILENAME"
echo "Removed temporary resources from: $GO_TMP_DIR"

echo ""
echo "Golang $GO_VERSION installed successfully!"

exit 0
