#!/bin/bash

set -e 

# Build
hugo

# Sync
aws s3 sync --acl "public-read" --sse "AES256" public/ s3://$BUCKET_NAME --exclude 'post'

# in the codebuild environment we need to set this to gain access
aws configure set preview.cloudfront true
# Invalidate
aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths /index.html / /page/*
