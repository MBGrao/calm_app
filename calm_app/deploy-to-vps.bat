@echo off
REM MeditAi VPS Deployment Script for Windows
REM VPS: 168.231.66.116

echo 🚀 Starting MeditAi VPS Deployment...

REM Check if SSH key is available
if not exist "%USERPROFILE%\.ssh\id_rsa" (
    echo ❌ SSH key not found. Please ensure your SSH key is set up.
    pause
    exit /b 1
)

echo 📦 Creating deployment package...
cd backend
tar -czf ..\meditai-backend.tar.gz --exclude=node_modules --exclude=.git --exclude=*.log --exclude=uploads/* --exclude=.env .
cd ..

echo 📤 Uploading to VPS...
scp meditai-backend.tar.gz root@168.231.66.116:/tmp/

echo 🔧 Deploying on VPS...
ssh root@168.231.66.116 "set -e && echo '📦 Installing dependencies and setting up MeditAi Backend...' && mkdir -p /opt/meditai-backend && cd /opt/meditai-backend && tar -xzf /tmp/meditai-backend.tar.gz && rm /tmp/meditai-backend.tar.gz && cp env.production .env && npm install --production && mkdir -p uploads && chown -R root:root /opt/meditai-backend && chmod -R 755 /opt/meditai-backend && cat > /etc/systemd/system/meditai-backend.service << 'EOF'
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
systemctl daemon-reload && systemctl enable meditai-backend && systemctl start meditai-backend && sleep 5 && systemctl status meditai-backend --no-pager && echo '✅ MeditAi Backend deployment completed!' && echo '🌐 Service URL: http://168.231.66.116:3000' && echo '🔗 Health Check: http://168.231.66.116:3000/health' && echo '📚 API Docs: http://168.231.66.116:3000/api/v1'"

echo 🧹 Cleaning up local files...
del meditai-backend.tar.gz

echo 🎉 Deployment completed successfully!
echo 🌐 Backend is now running at: http://168.231.66.116:3000
echo 🔗 Health Check: http://168.231.66.116:3000/health
echo 📚 API Documentation: http://168.231.66.116:3000/api/v1
echo.
echo 🧪 Testing deployment...
timeout /t 10 /nobreak >nul

echo 🔍 Testing backend health...
curl -s http://168.231.66.116:3000/health >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Backend health check passed!
) else (
    echo ❌ Backend health check failed!
)

echo 🔍 Testing API endpoint...
curl -s http://168.231.66.116:3000/api/v1 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ API endpoint accessible!
) else (
    echo ❌ API endpoint not accessible!
)

echo.
echo 🎉 All tests completed!
echo 🌐 Your MeditAi backend is now running on the VPS!
echo 📱 You can now test it with your Flutter app!
echo.
pause

