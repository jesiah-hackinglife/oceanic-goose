#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e7b5c657b4f3700143600ed/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e7b5c657b4f3700143600ed
curl -s -X POST https://api.stackbit.com/project/5e7b5c657b4f3700143600ed/webhook/build/ssgbuild > /dev/null
gatsby build
wait

curl -s -X POST https://api.stackbit.com/project/5e7b5c657b4f3700143600ed/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
