#!/bin/bash
set -e

# Input: NEW_LLM_KEY environment variable (from emergent_integrations_manager tool)
# Example: NEW_LLM_KEY="sk-emergent-54d8aE23aFf4e02159" ./restore.sh

SUPERVISOR_CONF="/etc/supervisor/conf.d/supervisord_code_server.conf"
FRONTEND_ENV="/app/frontend/.env"
OLD_URL_PATTERN="https://[a-zA-Z0-9-]*\.preview\.emergentagent\.com"

echo "=== Starting restore process ==="

# 1. Capture current password from supervisord config
echo "Capturing current password..."
CURRENT_PASSWORD=$(grep -oP 'environment=PASSWORD="\K[^"]+' "$SUPERVISOR_CONF")
if [ -z "$CURRENT_PASSWORD" ]; then
    echo "ERROR: Could not extract password from $SUPERVISOR_CONF"
    exit 1
fi
echo "Captured password: $CURRENT_PASSWORD"

# 2. Capture REACT_APP_BACKEND_URL from frontend .env
echo "Capturing REACT_APP_BACKEND_URL..."
BACKEND_URL=$(grep -oP 'REACT_APP_BACKEND_URL=\K.*' "$FRONTEND_ENV")
if [ -z "$BACKEND_URL" ]; then
    echo "ERROR: Could not extract REACT_APP_BACKEND_URL from $FRONTEND_ENV"
    exit 1
fi
echo "Captured REACT_APP_BACKEND_URL: $BACKEND_URL"

# 3. Stop all services before restore
echo "Stopping all services..."
supervisorctl stop all || true
sleep 2

# 4. Clean directories that will be restored (to avoid conflicts)
echo "Cleaning directories before restore..."
rm -rf /data/db/*
rm -rf /app/*
rm -rf /root/.* 2>/dev/null || true
rm -rf /var/log/* 2>/dev/null || true

# 5. Run restic restore (exclude build folder - will rebuild after)
echo "Running restic restore..."
export RESTIC_REPOSITORY="s3:s3.amazonaws.com/moltbot-emergent/molt-310126-2"

restic -o s3.unsafe-anonymous-auth=true --insecure-no-password --no-lock restore latest \
    --exclude /data/db \
    --exclude /app/frontend/build \
    --target / || {
    echo "ERROR: Restic restore failed"
    exit 1
}
echo "Restic restore completed"

# 6. Ensure clean MongoDB data directory (not restored from backup)
echo "Ensuring clean MongoDB data directory..."
rm -rf /data/db/*

# 7. Restore the password in supervisord config
echo "Restoring password in supervisord config..."
sed -i "s/environment=PASSWORD=\"[^\"]*\"/environment=PASSWORD=\"$CURRENT_PASSWORD\"/" "$SUPERVISOR_CONF"
echo "Password restored"

# 8. Install serve globally and update frontend supervisor command
echo "Installing serve globally..."
npm install -g serve
echo "Updating frontend supervisor command to include build..."
SUPERVISORD_MAIN="/etc/supervisor/conf.d/supervisord.conf"
sed -i 's|command=npx serve -s build -l 3000|command=yarn start|' "$SUPERVISORD_MAIN"
echo "Frontend command updated"

# 9. Replace all instances of *.preview.emergentagent.com URLs with captured BACKEND_URL
echo "Replacing preview URLs with $BACKEND_URL..."
# Use grep -rl for faster search, exclude node_modules
for file in $(grep -rlE "$OLD_URL_PATTERN" /app --include="*.env" --include="*.json" --exclude-dir=node_modules 2>/dev/null); do
    echo "  Updating: $file"
    sed -i -E "s|$OLD_URL_PATTERN|$BACKEND_URL|g" "$file"
done
echo "URL replacement completed"

# 10. Replace sk-emergent-* keys with NEW_LLM_KEY (if provided)
if [ -n "$NEW_LLM_KEY" ]; then
    echo "Replacing sk-emergent-* keys with $NEW_LLM_KEY..."
    # Known files that contain the key
    KEY_FILES=(
        "/app/backend/.env"
        "/root/.clawdbot/clawdbot.json"
        "/root/.clawdbot/moltbot.json"
        "/root/.clawdbot/agents/main/agent/models.json"
    )
    for file in "${KEY_FILES[@]}"; do
        if [ -f "$file" ] && grep -qE "sk-emergent-[a-zA-Z0-9]+" "$file" 2>/dev/null; then
            echo "  Updating: $file"
            sed -i -E "s|sk-emergent-[a-zA-Z0-9]+|$NEW_LLM_KEY|g" "$file"
        fi
    done
    echo "LLM key replacement completed"
else
    echo "No NEW_LLM_KEY provided, skipping key replacement"
fi

# 11. Create required directories
echo "Creating required directories..."
mkdir -p /var/log/supervisor
mkdir -p /var/log/nginx

# 12. Rebuild frontend with correct URLs baked in
echo "Rebuilding frontend..."
cd /app/frontend
npm run build || {
    echo "ERROR: Frontend build failed"
    exit 1
}
echo "Frontend rebuilt successfully"

# 13. Restart supervisor
echo "Starting all services..."
supervisorctl reread
supervisorctl update
supervisorctl start backend frontend mongodb nginx-code-proxy
echo "Services started"

# 14. Wait and check status
sleep 5
echo "=== Service Status ==="
supervisorctl status

echo ""
echo "=== INSTALLATION COMPLETE ==="
