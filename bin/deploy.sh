#!/bin/bash

set -euo pipefail

mix test

fly deploy \
    --build-secret FLUXON_KEY_FINGERPRINT=$FLUXON_KEY_FINGERPRINT \
    --build-secret FLUXON_LICENSE_KEY=$FLUXON_LICENSE_KEY
