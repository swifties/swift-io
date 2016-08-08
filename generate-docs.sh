#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}

VERSION=$(git status | head -n 1 | grep "On branch release/" | awk 'BEGIN {FS="/"}; {print $2}')

JAZZY=$(which jazzy)

if [ -z "${JAZZY}" ]; then
    echo "Please install 'jazzy' from https://github.com/realm/jazzy"
    exit 1
fi

jazzy \
  --clean \
  --author SWIFTIES \
  --author_url https://github.com/swifties \
  --github_url https://github.com/swifties/swift-io \
  --github-file-prefix https://github.com/swifties/swift-io/blob/release/${VERSION} \
  --module-version ${VERSION}

open docs/index.html
