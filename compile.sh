#!/bin/bash
# Script to compile an "ecr" plugin binary used for image credential retreval

plugin_version="${CREDENTIAL_PLUGIN_VERSION:-v1.21.0-alpha.0}"

# Clone

docker run
