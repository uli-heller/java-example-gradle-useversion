#!/bin/sh
D="$(dirname "$0")"
D="$(realpath "${D}")"

MAVEN_REPOSITORY="${D}/maven-repository"
MAVEN_REPOSITORY_URL="file://${MAVEN_REPOSITORY}"

rm -rf "${MAVEN_REPOSITORY}"

( cd hello-world; "${D}/gradlew" publish -Pversion=0.0.0 -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
( cd bye-moon; "${D}/gradlew" publish -Pversion=0.0.0 -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )

test "$1" -ge 1 && {
  ( cd hello-world; "${D}/gradlew" publish -Pversion=0.1.0 -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
  ( cd bye-moon; "${D}/gradlew" publish -Pversion=0.0.1 -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )
}
