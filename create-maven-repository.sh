#!/bin/sh
D="$(dirname "$0")"
D="$(realpath "${D}")"

MAVEN_REPOSITORY="${D}/maven-repository"
MAVEN_REPOSITORY_URL="file://${MAVEN_REPOSITORY}"

( cd hello-world; "${D}/gradlew" publish -PmavenRepositoryUrl="${MAVEN_REPOSITORY_URL}" )




