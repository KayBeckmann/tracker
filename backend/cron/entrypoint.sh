#!/bin/bash
set -euo pipefail

# Expose container environment variables to cron jobs.
printenv | grep -v "no_proxy" > /etc/environment

exec cron -f
