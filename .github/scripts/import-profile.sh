#!/bin/bash

set -euo pipefail

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
echo "$PROVISIONING_PROFILE_DATA" | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/50ecddf2-d491-4dbc-8dc0-9b93be56db1f.mobileprovision