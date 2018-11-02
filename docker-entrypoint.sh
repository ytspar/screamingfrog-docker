#!/bin/sh

## exec once with --help to create the config file
echo "Initializing container"
screamingfrogseospider "--help" > /dev/null

# Setup config
sed -i "s|Xmx2g|Xmx${SF_MEMORY} |g" ~/.screamingfrogseospider

# Start service
screamingfrogseospider "$@"