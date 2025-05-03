#!/usr/bin/env bash

set -eux

REPO_ROOT="$(git rev-parse --show-toplevel)"

die() {
  1>&2 echo $@
  exit 1
}

if ! nix --version; then
  die "Please install nix"
fi

cd "$REPO_ROOT"

if [[ "${IN_NIX_DEVSHELL:-0}" != "1" ]]; then
  exec nix develop -c "./develop/ci/unit-tests.sh"
fi

# We should be in our nix environment now

echo "Formatting all files"
treefmt

echo "Running go unit tests"
go test -race -timeout=30s ./...
