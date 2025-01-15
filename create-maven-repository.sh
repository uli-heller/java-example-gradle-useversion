#!/bin/sh
#
# ./create-maven-repository.sh (version-cnt)
#
D="$(dirname "$0")"
D="$(realpath "${D}")"

MAVEN_REPOSITORY="${D}/maven-repository"
MAVEN_REPOSITORY_URL="file://${MAVEN_REPOSITORY}"

rm -rf "${MAVEN_REPOSITORY}"

CNT="$1"
test -z "$CNT" && CNT=5

for V in $(seq 1 ${CNT}); do
  VERSION="0.${V}.0"
  ( cd hello-world; "${D}/gradlew" publish -Pversion=${VERSION} -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
  ( cd bye-moon; "${D}/gradlew" publish -Pversion=${VERSION} -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
done
