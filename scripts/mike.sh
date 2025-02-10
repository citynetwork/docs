#!/bin/sh

DOCS_DEPLOY_DEFAULT_BRANCH="${DOCS_DEPLOY_DEFAULT_BRANCH:-main}"
DOCS_DEPLOY_BRANCH="${DOCS_DEPLOY_BRANCH:-`git rev-parse --abbrev-ref HEAD`}"

mike deploy $DOCS_DEPLOY_BRANCH --allow-empty "$@"
mike set-default $DOCS_DEPLOY_DEFAULT_BRANCH "$@"
