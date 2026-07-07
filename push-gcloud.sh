#!/bin/sh
# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -e

usage() {
  echo "Usage: push-gcloud.sh [SRC_TAG] [DST_TAG]"
  echo ""
  echo "  Example usage: ./push-gcloud.sh [SRC_TAG] [DST_TAG]"
  echo ""
  echo "  SRC_TAG    The Google Cloud tag of the image to push. Default: 'latest'."
  echo "  DST_TAG    The Docker Hub tag to push to. Default: matches SRC_TAG."
  echo ""
  echo "  Note: Requires access to the docker-hub-password secret in"
  echo "        the carbon-language gcloud project."
  exit 1
}

SRC_TAG=$1
if [ "$SRC_TAG" = "--help" -o "$SRC_TAG" = "-h" ]; then
  usage
fi

if [ "$SRC_TAG" = "" ]; then
  SRC_TAG=latest
fi

DST_TAG=$2
if [ "$DST_TAG" = "" ]; then
  DST_TAG="$SRC_TAG"
fi

gcloud --project=carbon-language builds submit \
  --config=cloudbuild-push.yaml \
  --service-account=projects/carbon-language/serviceAccounts/carbon-fizz-bot-push@carbon-language.iam.gserviceaccount.com \
  --substitutions=_SRC_TAG="$SRC_TAG",_DST_TAG="$DST_TAG" \
  --no-source
