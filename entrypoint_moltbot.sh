#!/bin/bash
set -e

# Generate high-entropy suffix for URL if not set
if [ ! -f /app/frontend/.env ]; then
    RANDOM_SUFFIX=$(openssl rand -hex 8)
    echo "Creating mock frontend environment with secure suffix..."
    mkdir -p /app/frontend
    echo "REACT_APP_BACKEND_URL=http://moltbot-${RANDOM_SUFFIX}.local" > /app/frontend/.env
fi

# Ensure dummy supervisor config exists for password extraction
mkdir -p /etc/supervisor/conf.d
if [ ! -f /etc/supervisor/conf.d/supervisord_code_server.conf ]; then
    echo "Creating mock supervisor config..."
    echo 'environment=PASSWORD="changeMe123"' > /etc/supervisor/conf.d/supervisord_code_server.conf
fi

# Start supervisor in background
echo "Starting supervisord..."
supervisord -c /etc/supervisor/supervisord.conf

# Wait for supervisor to be ready
sleep 5

# Check if already installed (heuristic: check for a known restored file)
if [ ! -f /root/.clawdbot/clawdbot.json ]; then
    echo "MoltBot not found. Starting installation..."
    
    if [ -z "$NEW_LLM_KEY" ]; then
        echo "ERROR: NEW_LLM_KEY is not set!"
        exit 1
    fi

    # Run the installation (skip curl download, user provided or we use the fixed one)
    # We will download the restore script fresh to ensure we have the latest, 
    # but we might need to patch it on the fly if the grep issue persists (though ubuntu should have proper grep)
    
    echo "Downloading and running install script..."
    # Using the official install command
    bash -c "$(curl -fsSL https://moltbot.emergent.to/install.sh)" || {
        echo "Installation failed!"
        exit 1
    }
else
    echo "MoltBot appears to be already installed."
fi

# Keep container running by tailing logs
echo "Container is running. Tailing logs..."
tail -f /var/log/supervisor/supervisord.log
