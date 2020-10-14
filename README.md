[![CircleCI](https://circleci.com/gh/samsoir/go-development/tree/master.svg?style=shield)](https://circleci.com/gh/samsoir/go-development/tree/master)

# Install Golang

This repository installs a linux binary of Golang. It is designed to be used
as part of an automated provisioning process when bringing a new environment
into operation.

# How to use

This simple set of batch scripts will install Go language support into a
linux environment. This curerntly only supports amd64 architectures.

These instructions assume you start from your home directory. Please adjust
commands as required if you install the script in a different location.

## To install Go language

```
git clone git@github.com:samsoir/go-development.git
go-development/install.sh
```

## To uninstall Go language

```
go-development/uninstall.sh
```

# Current Version

The current Go version supported is 1.15.2, released 2020/09/09.

# How to contribute

Contributions to this project are welcome. This project uses the
[Github Flow](https://guides.github.com/introduction/flow/) workflow for
introducing changes to this project.

If you are not the maintainer, you should first clone this repository,
then create a branch and follow the standard Github Flow process. When you
are ready create a Pull Request against the main branch in maintainer
project.

# Testing

This project has tests that are automatically executed by CircleCI on each
commit and pull request.

The tests are executed using the [shUnit2 framework](https://github.com/kward/shunit2)
created by Katie Ward.

Testing is using an outside-in approach, where the expected result of each
action is tested, rather than the units of the functions themselves.

## Running Tests

Tests are run in a docker container using make command

```
make test
```

# License

Licensed under opensource MIT License. Terms included in [LICENSE](https://github.com/samsoir/go-development/blob/master/LICENSE) 
file.
