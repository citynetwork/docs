#!/bin/sh

BRANCHES="kna1 fra1 sto2 sto1hs sto2hs sto-com"
COMPARE_TO=${1:-`git rev-parse --abbrev-ref HEAD`}

echo "Comparing branches to ${COMPARE_TO}:"
echo

for branch in $BRANCHES; do
    echo "${branch}:"
    git cherry -v $branch ${COMPARE_TO}
    echo
done
