#!/bin/bash

set -o errexit
set -o nounset

GO_VERSION='1.12.3'
GO_TMP_DIR='/tmp'
GO_ARCH='amd64'
GO_OS='linux'
GO_VERSION_CHECKSUM='3924819eed16e55114f02d25d03e77c916ec40b7fd15c8acb5838b63135b03df'
GO_FILENAME="go${GO_VERSION}.${GO_OS}-${GO_ARCH}.tar.gz"
GO_URL="https://dl.google.com/go/${GO_FILENAME}"
GO_PATH='/usr/local'

echo_stderr() {
  (>&2 echo $@)
}

verify_checksum256() {
  checksum=$1
  file=$2

  computed=($(sha256sum $file))

  if [ "$checksum" = "${computed[0]}" ]
  then
    echo "Checksum verified $checksum"
    return 0
  else
    echo_stderr "Checksum values are not equal." 
    echo_stderr "Expected: $checksum"
    echo_stderr "Received: ${computed[0]}"
    return 1
  fi
}

go_version_installed() {
  if [ "go$1" != "$( gv=($(command -v go &> /dev/null && go version)); echo "${gv[2]-}" )" ]
  then
    return 0
  else
    return 1
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
  tar -C $2 -xzf $1
  if [ $? -eq 0 ]
  then
    echo "Installed $1 to $2/go"
    return 0
  else
    echo_stderr "Unable to extract file to $2. Exiting..."
    return 1
  fi
}

setup_go_environment() {
  echo "Setting up .zshrc with GOROOT, GOPATH and adding GOROOT/bin to PATH"
  # this assumes zsh for now
  echo "" >> ~/.zshrc
  echo "# Golang configuration -- created by golang install.sh" >> ~/.zshrc
  echo "export GOROOT=/usr/local/go" >> ~/.zshrc
  echo "export GOPATH=\$HOME/go" >> ~/.zshrc

  echo "Environment configured. Run source ~/.zshrc to load new configuration"
}

link_go_binary() {
  if [ ! -f $2 ]
  then
    ln -s $1 $2
    echo "Go binary linked into /usr/local/bin"
  else
    echo "Go binary already linked in /usr/local/bin"
  fi
}

remove_temporary_files() {
  if [ -f $1 ]
  then
    rm $1
    echo "Removed temporary resources: $1"
  fi
}

if go_version_installed $GO_VERSION
then
  echo "Go version found"
  exit 0
fi

if remote_file_to_target $GO_URL "$GO_TMP_DIR/$GO_FILENAME"
then
  if verify_checksum256 "${GO_VERSION_CHECKSUM}" "$GO_TMP_DIR/$GO_FILENAME"
  then
    echo "Download completed and verified."
  else
    exit 1
  fi
else
  echo_stderr "Download failed!"
  exit 1
fi

if extract_go_package_to_target "$GO_TMP_DIR/$GO_FILENAME" "$GO_PATH"
then
  setup_go_environment
  link_go_binary "/usr/local/go/bin/go" "/usr/local/bin/go"
fi

remove_temporary_files "$GO_TMP_DIR/$GO_FILENAME"
echo ""
echo "Golang $GO_VERSION installed successfully!"
