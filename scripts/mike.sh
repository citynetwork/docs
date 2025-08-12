#!/bin/sh

title_case() {
    echo -n "$@" | sed -e 's/\<\([[:lower:]]\)\([[:alnum:]]*\)/\u\1\2/g'
}

DOCS_DEPLOY_DEFAULT_BRANCH="${DOCS_DEPLOY_DEFAULT_BRANCH:-main}"
mike_default_version_name="title_case ${DOCS_DEPLOY_DEFAULT_BRANCH}"

DOCS_DEPLOY_BRANCH="${DOCS_DEPLOY_BRANCH:-`git rev-parse --abbrev-ref HEAD`}"
mike_version_name=`title_case "${DOCS_DEPLOY_BRANCH}"`
mike_version_alias="${DOCS_DEPLOY_BRANCH}"

mike deploy \
     --allow-empty \
     $mike_version_name \
     $mike_version_alias \
     "$@"

mike set-default $mike_default_version_name "$@"
