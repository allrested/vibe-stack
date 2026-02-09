#!/bin/bash

# Only for interactive shells
[[ $- != *i* ]] && return

# Only for node user
[ "$(whoami)" != "node" ] && return

INSTALLED_FLAG="/home/node/.openclaw/.installed"

# Already installed - show quick help
if [ -f "$INSTALLED_FLAG" ]; then
    echo ""
    echo "Welcome back to OpenClaw (Moltbot)!"
    echo "  openclaw gateway --bind lan    Start gateway"
    echo "  openclaw doctor                Check config"
    echo ""
    return
fi

# First-time - show install instructions
clear
echo "======================================"
echo "  OpenClaw (Moltbot) Setup           "
echo "======================================"
echo ""
echo "OpenClaw is not installed yet."
echo ""
echo "To install, run this command:"
echo ""
echo "  curl -fsSL https://openclaw.ai/install.sh | bash"
echo ""
echo "After installation completes, start the gateway with:"
echo "  openclaw gateway --bind lan"
echo ""
