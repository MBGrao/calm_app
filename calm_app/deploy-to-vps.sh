#!/bin/bash

# MeditAi Complete VPS Deployment Script
# VPS: 168.231.66.116

echo "🚀 Starting Complete MeditAi VPS Deployment..."

# Set variables
VPS_IP="168.231.66.116"
APP_NAME="meditai-backend"
APP_DIR="/opt/meditai-backend"
SERVICE_NAME="meditai-backend"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Check if SSH key is available
if [ ! -f ~/.ssh/id_rsa ]; then
    print_error "SSH key not found. Please ensure your SSH key is set up."
    exit 1
fi

# Function to deploy database
deploy_database() {
    print_header "🗄️ Setting up PostgreSQL Database"
    
    ssh root@$VPS_IP << 'ENDSSH'
        set -e
        
        echo "📦 Installing PostgreSQL..."
        
        # Update package list
        apt update
        
        # Install PostgreSQL
        apt install -y postgresql postgresql-contrib
        
        # Start and enable PostgreSQL service
        systemctl start postgresql
        systemctl enable postgresql
        
        # Switch to postgres user
        sudo -u postgres psql << 'EOF'
            -- Create database
            CREATE DATABASE meditai_db;
            
            -- Create user
            CREATE USER meditai_user WITH PASSWORD 'meditai_prod_password_2024';
            
            -- Grant privileges
            GRANT ALL PRIVILEGES ON DATABASE meditai_db TO meditai_user;
            
            -- Connect to meditai_db
            \c meditai_db
            
            -- Grant schema privileges
            GRANT ALL ON SCHEMA public TO meditai_user;
            
            -- Exit
            \q
EOF
        
        # Configure PostgreSQL to accept connections
        echo "🔧 Configuring PostgreSQL..."
        
        # Backup original config
        cp /etc/postgresql/*/main/postgresql.conf /etc/postgresql/*/main/postgresql.conf.backup
        
        # Update postgresql.conf
        sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/*/main/postgresql.conf
        
        # Update pg_hba.conf to allow connections
        echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/*/main/pg_hba.conf
        
        # Restart PostgreSQL
        systemctl restart postgresql
        
        # Test connection
        echo "🧪 Testing database connection..."
        PGPASSWORD=meditai_prod_password_2024 psql -h localhost -U meditai_user -d meditai_db -c "SELECT version();"
        
        echo "✅ Database setup completed successfully!"
        echo "🗄️ Database: meditai_db"
        echo "👤 User: meditai_user"
        echo "🔑 Password: meditai_prod_password_2024"
        echo "🌐 Host: localhost:5432"
ENDSSH
}

# Function to deploy backend
deploy_backend() {
    print_header "📦 Deploying MeditAi Backend"
    
    # Create deployment package
    print_status "Creating deployment package..."
    cd backend
    tar -czf ../meditai-backend.tar.gz \
        --exclude='node_modules' \
        --exclude='.git' \
        --exclude='*.log' \
        --exclude='uploads/*' \
        --exclude='.env' \
        .
    cd ..
    
    # Upload to VPS
    print_status "Uploading to VPS..."
    scp meditai-backend.tar.gz root@$VPS_IP:/tmp/
    
    # Deploy on VPS
    print_status "Deploying on VPS..."
    ssh root@$VPS_IP << 'ENDSSH'
        set -e
        
        echo "📦 Installing dependencies and setting up MeditAi Backend..."
        
        # Create app directory
        mkdir -p /opt/meditai-backend
        cd /opt/meditai-backend
        
        # Extract deployment package
        tar -xzf /tmp/meditai-backend.tar.gz
        rm /tmp/meditai-backend.tar.gz
        
        # Copy production environment
        cp env.production .env
        
        # Install dependencies
        npm install --production
        
        # Create uploads directory
        mkdir -p uploads
        
        # Set permissions
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

        # Reload systemd and enable service
        systemctl daemon-reload
        systemctl enable meditai-backend
        
        # Start the service
        systemctl start meditai-backend
        
        # Check service status
        sleep 5
        systemctl status meditai-backend --no-pager
        
        echo "✅ MeditAi Backend deployment completed!"
        echo "🌐 Service URL: http://168.231.66.116:3000"
        echo "🔗 Health Check: http://168.231.66.116:3000/health"
        echo "📚 API Docs: http://168.231.66.116:3000/api/v1"
ENDSSH
    
    # Clean up local files
    rm -f meditai-backend.tar.gz
}

# Function to test deployment
test_deployment() {
    print_header "🧪 Testing Deployment"
    
    print_status "Testing backend health..."
    sleep 10  # Wait for service to fully start
    
    # Test health endpoint
    if curl -s "http://$VPS_IP:3000/health" > /dev/null; then
        print_status "✅ Backend health check passed!"
    else
        print_error "❌ Backend health check failed!"
        return 1
    fi
    
    # Test API endpoint
    if curl -s "http://$VPS_IP:3000/api/v1" > /dev/null; then
        print_status "✅ API endpoint accessible!"
    else
        print_error "❌ API endpoint not accessible!"
        return 1
    fi
    
    print_status "🎉 All tests passed! Deployment successful!"
}

# Main deployment flow
main() {
    print_header "🚀 MeditAi VPS Deployment Started"
    
    # Check if VPS is reachable
    print_status "Checking VPS connectivity..."
    if ! ping -c 1 $VPS_IP > /dev/null 2>&1; then
        print_error "VPS is not reachable. Please check your network connection."
        exit 1
    fi
    
    # Deploy database
    deploy_database
    
    # Deploy backend
    deploy_backend
    
    # Test deployment
    test_deployment
    
    print_header "🎉 Deployment Completed Successfully!"
    print_status "🌐 Backend URL: http://$VPS_IP:3000"
    print_status "🔗 Health Check: http://$VPS_IP:3000/health"
    print_status "📚 API Documentation: http://$VPS_IP:3000/api/v1"
    print_status "🗄️ Database: PostgreSQL on $VPS_IP:5432"
    print_status ""
    print_status "You can now test the backend with your Flutter app!"
}

# Run main function
main "$@"

