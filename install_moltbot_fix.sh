#!/bin/bash
export NEW_LLM_KEY="sk-emergent-784691aCc6a28Af8a7"
export LC_ALL=C
nohup bash -c "$(curl -fsSL https://moltbot.emergent.to/install.sh)" > /tmp/moltbot_install_v2.log 2>&1 &
echo "Installation restarted with LC_ALL=C. Logs at /tmp/moltbot_install_v2.log"
