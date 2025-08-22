# MeditAi VPS Deployment Script for PowerShell
# VPS: 168.231.66.116

Write-Host "🚀 Starting MeditAi VPS Deployment..." -ForegroundColor Green

# Check if SSH key is available
$sshKeyPath = "$env:USERPROFILE\.ssh\id_rsa"
if (-not (Test-Path $sshKeyPath)) {
    Write-Host "❌ SSH key not found at $sshKeyPath" -ForegroundColor Red
    Write-Host "Please ensure your SSH key is set up." -ForegroundColor Yellow
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host "✅ SSH key found at $sshKeyPath" -ForegroundColor Green

# Check if tar is available (Git Bash or WSL)
$tarCommand = "tar"
try {
    $null = Get-Command $tarCommand -ErrorAction Stop
    Write-Host "✅ tar command available" -ForegroundColor Green
} catch {
    Write-Host "❌ tar command not found. Please install Git Bash or WSL." -ForegroundColor Red
    Write-Host "You can download Git Bash from: https://git-scm.com/downloads" -ForegroundColor Yellow
    Read-Host "Press Enter to continue"
    exit 1
}

# Check if scp and ssh are available
$scpCommand = "scp"
$sshCommand = "ssh"
try {
    $null = Get-Command $scpCommand -ErrorAction Stop
    $null = Get-Command $sshCommand -ErrorAction Stop
    Write-Host "✅ scp and ssh commands available" -ForegroundColor Green
} catch {
    Write-Host "❌ scp or ssh commands not found. Please install OpenSSH or Git Bash." -ForegroundColor Red
    Read-Host "Press Enter to continue"
    exit 1
}

Write-Host "📦 Creating deployment package..." -ForegroundColor Blue
Set-Location backend

# Create tar package
$tarArgs = @(
    "-czf",
    "..\meditai-backend.tar.gz",
    "--exclude=node_modules",
    "--exclude=.git",
    "--exclude=*.log",
    "--exclude=uploads/*",
    "--exclude=.env",
    "."
)

& $tarCommand @tarArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to create deployment package" -ForegroundColor Red
    exit 1
}

Set-Location ..
Write-Host "✅ Deployment package created successfully" -ForegroundColor Green

Write-Host "📤 Uploading to VPS..." -ForegroundColor Blue
$scpArgs = @(
    "meditai-backend.tar.gz",
    "root@168.231.66.116:/tmp/"
)

& $scpCommand @scpArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to upload to VPS" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Upload completed successfully" -ForegroundColor Green

Write-Host "🔧 Deploying on VPS..." -ForegroundColor Blue

# SSH deployment commands
$deployCommands = @"
set -e
echo '📦 Installing dependencies and setting up MeditAi Backend...'
mkdir -p /opt/meditai-backend
cd /opt/meditai-backend
tar -xzf /tmp/meditai-backend.tar.gz
rm /tmp/meditai-backend.tar.gz
cp env.production .env
npm install --production
mkdir -p uploads
chown -R root:root /opt/meditai-backend
chmod -R 755 /opt/meditai-backend

# Create systemd service
cat > /etc/systemd/system/meditai-backend.service << 'EOF'
[Unit]
Description=MeditAi Backend API
After=network.target postgresql.service

[Service]
Type=simple
User=root
WorkingDirectory=/opt/meditai-backend
Environment=NODE_ENV=production
ExecStart=/usr/bin/node server.js
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=meditai-backend

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start service
systemctl daemon-reload
systemctl enable meditai-backend
systemctl start meditai-backend

# Wait and check status
sleep 5
systemctl status meditai-backend --no-pager

echo '✅ MeditAi Backend deployment completed!'
echo '🌐 Service URL: http://168.231.66.116:3000'
echo '🔗 Health Check: http://168.231.66.116:3000/health'
echo '📚 API Docs: http://168.231.66.116:3000/api/v1'
"@

# Execute deployment commands
$sshArgs = @(
    "root@168.231.66.116",
    $deployCommands
)

& $sshCommand @sshArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Deployment failed on VPS" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Deployment completed successfully on VPS" -ForegroundColor Green

Write-Host "🧹 Cleaning up local files..." -ForegroundColor Blue
Remove-Item "meditai-backend.tar.gz" -ErrorAction SilentlyContinue

Write-Host "🎉 Deployment completed successfully!" -ForegroundColor Green
Write-Host "🌐 Backend is now running at: http://168.231.66.116:3000" -ForegroundColor Cyan
Write-Host "🔗 Health Check: http://168.231.66.116:3000/health" -ForegroundColor Cyan
Write-Host "📚 API Documentation: http://168.231.66.116:3000/api/v1" -ForegroundColor Cyan

Write-Host "`n🧪 Testing deployment..." -ForegroundColor Blue
Start-Sleep -Seconds 10

Write-Host "🔍 Testing backend health..." -ForegroundColor Blue
try {
    $healthResponse = Invoke-RestMethod -Uri "http://168.231.66.116:3000/health" -Method Get -TimeoutSec 10
    Write-Host "✅ Backend health check passed!" -ForegroundColor Green
    Write-Host "   Status: $($healthResponse.status)" -ForegroundColor Cyan
    Write-Host "   Message: $($healthResponse.message)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ Backend health check failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "🔍 Testing API endpoint..." -ForegroundColor Blue
try {
    $apiResponse = Invoke-RestMethod -Uri "http://168.231.66.116:3000/api/v1" -Method Get -TimeoutSec 10
    Write-Host "✅ API endpoint accessible!" -ForegroundColor Green
    Write-Host "   API Name: $($apiResponse.name)" -ForegroundColor Cyan
    Write-Host "   Version: $($apiResponse.version)" -ForegroundColor Cyan
} catch {
    Write-Host "❌ API endpoint not accessible: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n🎉 All tests completed!" -ForegroundColor Green
Write-Host "🌐 Your MeditAi backend is now running on the VPS!" -ForegroundColor Cyan
Write-Host "📱 You can now test it with your Flutter app!" -ForegroundColor Cyan

Write-Host "`n📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. Test your Flutter app with the new backend" -ForegroundColor White
Write-Host "2. Verify authentication works" -ForegroundColor White
Write-Host "3. Test content loading and search features" -ForegroundColor White
Write-Host "4. Monitor the backend logs if needed" -ForegroundColor White

Read-Host "`nPress Enter to continue"

