#!/bin/bash

set -eo pipefail

script_dir=$(dirname "$0")
cd $script_dir/..

# This tom foolery gets rid of local-file replace directives in our go.mod
# before we invoke gazelle update-repos. These local replace directives are
# manually maintained as local_repository bazel workspaces and do not need to
# be see by gazelle. gazelle does not support these replace directives and will
# error if it sees them.
#
# The `go list -m all` at the end ensures our go.sum looks right to the
# update-repos invocation. That runs with -mod=readonly and will error if
# go.sum would change during the invocation.

cp -f go/go.mod go/go.mod.bak
trap 'mv -f go/go.mod.bak go/go.mod; rm -f go/go.mod.new; (cd go; go mod tidy)' EXIT
cp go/go.mod go/go.mod.new
(cd go; go list -m all > /dev/null)

# And we're ready to run update-repos.

bazel run //:gazelle -- \
      update-repos \
      -from_file=go/go.mod \
      -prune \
      -build_file_proto_mode disable_global \
      -to_macro=bazel/go_repositories.bzl%go_repositories

# We put a hash of go_repositories.bzl at the bottom of WORKSPACE. This was
# necessary to get bazel to always see the changes at one point.

h=`md5sum bazel/go_repositories.bzl`
sed -i '' 's|# .* bazel/go_repositories.bzl$|# '"$h"'|' WORKSPACE
