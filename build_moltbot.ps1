$ErrorActionPreference = "Stop"

# Configuration
$ImageName = "moltbot-local"
$ContainerName = "moltbot"
$LLM_KEY = "sk-emergent-784691aCc6a28Af8a7"

Write-Host "Building Docker image: $ImageName..."
docker build -t $ImageName -f Dockerfile.moltbot .

# Stop and remove existing container if it exists
if (docker ps -a -q -f name=$ContainerName) {
    Write-Host "Removing existing container..."
    docker rm -f $ContainerName
}

Write-Host "Running container: $ContainerName..."
# Running detached, passing the key env var
docker run -d `
    --name $ContainerName `
    -e NEW_LLM_KEY="$LLM_KEY" `
    -p 8088:80 `
    $ImageName

Write-Host "Container started on port 8088."
Write-Host "Logs can be viewed with: docker logs -f $ContainerName"
