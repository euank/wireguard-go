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

echo "Testing build for all architectures"

mkdir bin

# Format of 'go tool dist list' is 'GOOS/GOARCH'
go tool dist list | while IFS=/ read -r goos goarch; do
  if [ -z "$goos" ] || [ -z "$goarch" ]; then
    continue
  fi
  if [[ "$goos" =~ ^aix|android|dragonfly|illumos|ios|js|netbsd|plan9|solaris|wasip1|windows$ ]]; then
    continue
  fi

  echo "Build $goos/$goarch"
  GOOS="$goos" GOARCH="$goarch" go build -o "bin/wireguard-go-$goos-$goarch"
done
