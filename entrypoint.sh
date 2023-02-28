#!/bin/sh -l

export REPOSITORY_PATH=/tmp/repository
export COMMENT=$1
export JIRA_SERVER_URL=$2
export JIRA_API_TOKEN=$3
export JIRA_EMAIL=$4
GITHUB_REPOSITORY=$5
GITHUB_SHA=$6
GITHUB_TOKEN=$7

git clone https://${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git ${REPOSITORY_PATH}
cd ${REPOSITORY_PATH}
git -c advice.detachedHead=false checkout $GITHUB_SHA

jira_issue_key=$(ruby /script.rb $REPOSITORY_PATH)
echo "jira_issue_key=$jira_issue_key" >> $GITHUB_OUTPUT
