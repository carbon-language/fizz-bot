#!/bin/sh
# Part of the Carbon Language project, under the Apache License v2.0 with LLVM
# Exceptions. See /LICENSE for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -e

usage() {
  echo "Usage: run-gcloud-run.sh [TAG]"
  echo ""
  echo "  TAG    The tag of the image to run in Google Cloud. Default: 'latest'."
  exit 1
}

TAG=$1
if [ "$TAG" = "--help" -o "$TAG" = "-h" ]; then
  usage
fi

if [ "$TAG" = "" ]; then
  TAG=latest
fi

MODE="staging"
SECRET_TOKEN="carbon-fizz-bot-discord-token-$MODE"

IMAGE="gcr.io/carbon-language/fizz-bot:$TAG"

REGION="us-central1"
PROJECT="carbon-language"
SA_EMAIL="carbon-fizz-bot@carbon-language.iam.gserviceaccount.com"
JOB_NAME="fizz-bot-test-$MODE"

# Deploy/update the Cloud Run job.
# We mount the GCS bucket carbon-fizz-bot-config to /config, point FIZZ_CONFIG_DIR to /config/staging, and get the discord token from its secret.
echo "Deploying Cloud Run job '$JOB_NAME'..."
gcloud --project=$PROJECT run jobs deploy $JOB_NAME \
  --image=$IMAGE \
  --region=$REGION \
  --tasks=1 \
  --max-retries=0 \
  --service-account=$SA_EMAIL \
  --set-env-vars=FIZZ_CONFIG_DIR=/config/$MODE \
  --add-volume=name=fizz-config,type=cloud-storage,bucket=carbon-fizz-bot-config \
  --add-volume-mount=volume=fizz-config,mount-path=/config \
  --set-secrets="DISCORD_TOKEN=${SECRET_TOKEN}:latest" \
  --quiet

# Execute the Cloud Run job.
echo "Executing Cloud Run job '$JOB_NAME'..."
EXECUTION_LINE=$(gcloud --project=$PROJECT run jobs execute $JOB_NAME --region=$REGION --format="value(metadata.name)")
echo "--------------------------------------------------------"
echo "Job execution started: $EXECUTION_LINE"
echo "To stop the bot, run:"
echo "  gcloud --project=$PROJECT run jobs executions cancel $EXECUTION_LINE --region=$REGION"
echo ""
echo "To view logs, run:"
echo "  gcloud --project=$PROJECT logging read \"resource.type=cloud_run_job AND resource.labels.job_name=$JOB_NAME\" --limit 50"
echo ""
echo "To watch logs in real-time, run:"
echo "  gcloud --project=$PROJECT alpha logging tail --format=\"value(textPayload)\"  \"resource.type=cloud_run_job AND resource.labels.job_name=$JOB_NAME\""
echo ""
echo "Note: Job will automatically be cancelled in 10 minutes."
echo "--------------------------------------------------------"
