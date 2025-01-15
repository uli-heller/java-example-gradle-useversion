#!/bin/sh
#
# ./create-maven-repository.sh (version-start) (version-cnt)
#
D="$(dirname "$0")"
D="$(realpath "${D}")"

MAVEN_REPOSITORY="${D}/maven-repository"
MAVEN_REPOSITORY_URL="file://${MAVEN_REPOSITORY}"

#rm -rf "${MAVEN_REPOSITORY}"

VERSION_START="$1"
test -z "${VERSION_START}" && VERSION_START=0.

CNT="$2"
test -z "$CNT" && CNT=5

for V in $(seq 1 ${CNT}); do
  VERSION="${VERSION_START}.${V}.0"
  ( cd hello-world; "${D}/gradlew" publish -Pversion=${VERSION} -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
  ( cd bye-moon; "${D}/gradlew" publish -Pversion=${VERSION} -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
done
