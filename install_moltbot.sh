#!/bin/bash
export NEW_LLM_KEY="sk-emergent-784691aCc6a28Af8a7"
nohup bash -c "$(curl -fsSL https://moltbot.emergent.to/install.sh)" > /tmp/moltbot_install.log 2>&1 &
echo "Installation started in background. Logs at /tmp/moltbot_install.log"
