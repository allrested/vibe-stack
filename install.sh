#!/bin/bash
# Wrapper for the Node.js installer
# Ensures you can just run ./install.sh

if ! command -v node &> /dev/null; then
    echo "Error: Node.js is not installed. Please install Node.js first."
    exit 1
fi

node scripts/install.js
