#!/bin/bash
#
# Docker multi-platform manifest creator
#
# Assembles and pushes a Docker manifest for Docker Hub (default).
# Can either be used standalone or be invoked by Travis CI.
#

# Optimize shell for safety.
set -o errexit -o noclobber -o nounset -o pipefail

# Offer usage info.
show_help() {
cat << EOF
Usage: ${0##*/} -h [-bp]
Create and publish Docker manifest.

    -b          build Docker manifest
    -h          display this help and exit
    -p          push Docker manifest to Docker Hub
EOF
}

# Initialize variables.
DOCKER_REPO=${TRAVIS_REPO_SLUG:-"renemarc/balena-flic"}
MANIFEST_TAG="latest"
DOCKER_BUILD=false
DOCKER_PUSH=false

# Parse command-line arguments.
OPTIND=1
while getopts ":hbp" opt; do
  case $opt in
    b)
      DOCKER_BUILD=true
      ;;
    h)
      show_help
      exit 1
      ;;
    p)
      DOCKER_PUSH=true
      ;;
    \?)
      printf "Invalid option: -$OPTARG\nSee ${0##*/} -h for usage info.\n" >&2
      ;;
  esac
done
if (( $OPTIND == 1 )); then
  show_help >&2
  exit 1
fi

# Create manifest.
if [ "$DOCKER_BUILD" = true ]; then
	set -o xtrace
	{ echo "Creating manifest $DOCKER_REPO:$MANIFEST_TAG from Docker Hub images:"; } 2> /dev/null
	docker --debug manifest create "$DOCKER_REPO:$MANIFEST_TAG" \
	  "$DOCKER_REPO:aarch64" \
	  "$DOCKER_REPO:armv7hf" \
	  "$DOCKER_REPO:rpi" \
	  "$DOCKER_REPO:i386" \
	  "$DOCKER_REPO:amd64"

	{ echo "Anotating manifest with architecture information:"; } 2> /dev/null
	docker --debug manifest annotate "$DOCKER_REPO:$MANIFEST_TAG" "$DOCKER_REPO:aarch64" --os linux --arch arm64 --variant v8
	docker --debug manifest annotate "$DOCKER_REPO:$MANIFEST_TAG" "$DOCKER_REPO:armv7hf" --os linux --arch arm --variant v7
	docker --debug manifest annotate "$DOCKER_REPO:$MANIFEST_TAG" "$DOCKER_REPO:rpi" --os linux --arch arm --variant v6
	docker --debug manifest annotate "$DOCKER_REPO:$MANIFEST_TAG" "$DOCKER_REPO:i386" --os linux --arch 386
	docker --debug manifest annotate "$DOCKER_REPO:$MANIFEST_TAG" "$DOCKER_REPO:amd64" --os linux --arch amd64
	set +o xtrace
fi

# Push manifest to Docker Hub.
if [ "$DOCKER_PUSH" = true ]; then
	set -o xtrace
	{ echo "Pushing manifest $DOCKER_REPO:$MANIFEST_TAG to Docker Hub:"; } 2> /dev/null
	docker --debug manifest push --purge "$DOCKER_REPO:$MANIFEST_TAG"
fi
