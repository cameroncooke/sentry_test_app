# Sentry Test Repository

A test iOS project for end-to-end testing of [Sentry's Size Analysis](https://docs.sentry.io/product/size-analysis/) feature and GitHub status checks integration.

## Overview

This repository contains a minimal iOS app used to test the Size Analysis CI workflow. It demonstrates:

- Building an iOS xcarchive via Fastlane
- Uploading builds to Sentry for size analysis
- GitHub status checks for PR size comparisons

## GitHub Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `sentry-main.yaml` | Push to `main` | Uploads base builds for comparison |
| `sentry-pr.yaml` | Pull requests | Uploads head builds, triggers status checks |

## Required Secrets

| Secret | Description |
|--------|-------------|
| `SENTRY_AUTH_TOKEN` | Sentry authentication token |
| `SENTRY_URL` | Sentry instance URL |

## Local Development

```bash
cd test

# Install dependencies
bundle install

# Run the build & upload lane
SENTRY_URL=https://your-sentry-instance/ \
SENTRY_AUTH_TOKEN=your-token \
bundle exec fastlane ios build_upload_sentry
```

## Documentation

- [Sentry Size Analysis](https://docs.sentry.io/product/size-analysis/)
- [iOS Size Analysis Guide](https://docs.sentry.io/platforms/apple/guides/ios/size-analysis/)
- [CI Integration](https://docs.sentry.io/product/size-analysis/integrating-into-ci/)
