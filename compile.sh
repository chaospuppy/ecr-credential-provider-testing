#!/bin/bash
# Script to compile an "ecr" plugin binary used for image credential retreval
set -euo pipefail

plugin_version="${CREDENTIAL_PLUGIN_VERSION:-v1.21.0-alpha.0}"
tmpdir=$(mktemp -d)
declare -a deplist=(docker git)

check_dependency() {
  if ! command -v "${1}" >/dev/null 2>&1; then
    echo "$1 must be installed"
    exit 1
  fi
}

cleanup() {
  rm -rf "${tmpdir}"
}

for dep in ${deplist[@]}; do
  check_dependency ${dep}
done

# Clone source for binary
git clone https://github.com/kubernetes/cloud-provider-aws.git "${tmpdir}"

# Change branch to appropriate tag
cd ${tmpdir}/
git checkout ${plugin_version}

# Compile provider plugin for ecr and rename binary to ecr in current directory
docker run -v "${PWD}":/go/src/ --rm -it golang:stretch /bin/bash -c "cd src/; make ecr-credential-provider"
cd -
cp "${tmpdir}/ecr-credential-provider" ecr

# Clean
trap cleanup EXIT
