#!/bin/bash
set -e

iris start IRIS

# Keep container running
tail -f /dev/null