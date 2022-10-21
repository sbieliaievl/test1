#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
  cd "${GITHUB_WORKSPACE}" || exit
fi

# Setup these env variables. It can exit 0 for unknown label.
# - LABELS
setup_from_labeled_event() {
  echo "setup_from_labeled_event"
  label=$(jq -r '.label.name' < "${GITHUB_EVENT_PATH}")
  if echo "${label}" | grep "^bump:" ; then
    echo "Found label=${label}" >&2
    LABELS="${label}"
  else
    echo "Attached label name does not match with 'bump:'. label=${label}" >&2
    exit 0
  fi
}

# Setup these env variables.
# - LABELS
setup_from_push_event() {
  echo "setup_from_push_event"
  echo "finding PR with SHA ${GITHUB_SHA}"
  pull_request="$(list_pulls | jq ".[] | select(.merge_commit_sha==\"${GITHUB_SHA}\")" | tr -d '\n')"
  echo "${pull_request}"
  LABELS="$(list_pulls | jq ".[] | select(.merge_commit_sha==\"${GITHUB_SHA}\")" | tr -d '\n\r' | jq '.labels | .[].name')"
}

list_pulls() {
  pulls_endpoint="https://api.github.com/repos/${GITHUB_REPOSITORY}/pulls?state=closed&sort=updated&direction=desc"
  if [ -n "${GITHUB_TOKEN}" ]; then
    curl -s -H "Authorization: token ${GITHUB_TOKEN}" "${pulls_endpoint}"
  else
    echo "GITHUB_TOKEN is not available. Subscequent GitHub API call may fail due to API limit." >&2
    curl -s "${pulls_endpoint}"
  fi
}

# Get labels and Pull Request data.
ACTION=$(jq -r '.action' < "${GITHUB_EVENT_PATH}" )
if [ "${ACTION}" = "labeled" ]; then
  setup_from_labeled_event
else
  setup_from_push_event
fi

echo "Got labels"
echo "${LABELS}"
INCREMENT_LEVEL=""
if echo "${LABELS}" | grep "bump:major" ; then
  INCREMENT_LEVEL="major"
elif echo "${LABELS}" | grep "bump:minor" ; then
  INCREMENT_LEVEL="minor"
elif echo "${LABELS}" | grep "bump:patch" ; then
  INCREMENT_LEVEL="patch"
elif echo "${LABELS}" | grep "bump:auto" ; then
  INCREMENT_LEVEL="auto"
fi

if [ -z "${INCREMENT_LEVEL}" ]; then
  echo "PR with labels for bump not found. Do nothing."
  echo "::set-output name=skip::true"
  exit
fi

echo "Increment ${INCREMENT_LEVEL} version"
echo "::set-output name=increment::${INCREMENT_LEVEL}"
exit
