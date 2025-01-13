#!/usr/bin/env bash

set -euo pipefail

set -x

formulae=$(brew tap-info bigbang/tools-public --json | jq --raw-output '.[].formula_names[]')

for formula in $formulae; do
  brew install "$formula"
  brew test --verbose --debug "$formula"
done