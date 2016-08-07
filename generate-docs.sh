#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${DIR}

VERSION=$(git status | head -n 1 | grep "On branch release/" | awk 'BEGIN {FS="/"}; {print $2}')

jazzy \
  --clean \
  --author SWIFTIES \
  --author_url https://github.com/swifties \
  --github_url https://github.com/swifties/swift-io \
  --github-file-prefix https://github.com/swifties/swift-io/tree/${VERSION} \
  --module-version ${VERSION}
