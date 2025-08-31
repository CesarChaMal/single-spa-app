#!/bin/bash
# Single-SPA Microfrontend Manager
# Usage:
#   ./microfrontend.sh          - Setup, clean, install and start all microfrontends
#   ./microfrontend.sh setup    - Setup Node.js and yarn only
#   ./microfrontend.sh clean    - Clean dependencies and build artifacts
#   ./microfrontend.sh build    - Build all packages for production
#   ./microfrontend.sh stop     - Stop all running services
#   ./microfrontend.sh individual - Start individual microfrontend

install_yarn() {
    echo "Setting up yarn..."
    
    # Try normal installation first (with --force to overwrite existing files)
    npm install -g yarn@1.22.19 --force 2>/dev/null || npm install -g yarn@1.22.19
    
    # Test if yarn works
    if yarn --version >/dev/null 2>&1; then
        echo "Yarn installed successfully: $(yarn --version)"
        return 0
    fi
    
    echo "Normal yarn installation failed, applying fix for Windows/Anaconda conflicts..."
    
    # Completely remove all yarn installations
    npm uninstall -g yarn 2>/dev/null || true
    
    # Clean all possible yarn locations
    CURRENT_NODE_PATH=$(which node 2>/dev/null || where node 2>/dev/null | head -1)
    if [ -n "$CURRENT_NODE_PATH" ]; then
        NODE_DIR=$(dirname "$CURRENT_NODE_PATH")
        rm -rf "$NODE_DIR/node_modules/yarn" 2>/dev/null || true
        rm -f "$NODE_DIR/yarn"* "$NODE_DIR/yarnpkg"* 2>/dev/null || true
    fi
    
    # Remove from Anaconda paths (Windows/Git Bash)
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        USER_HOME=$(echo $HOME | sed 's|/c/Users|C:/Users|')
        if [ -n "$USER_HOME" ]; then
            find "$USER_HOME" -name "*yarn*" -path "*/anaconda3/*" -exec rm -rf {} + 2>/dev/null || true
        fi
        if [ -n "$CONDA_PREFIX" ]; then
            find "$CONDA_PREFIX" -name "*yarn*" -exec rm -rf {} + 2>/dev/null || true
        fi
    fi
    
    # Remove from snap paths (Pop!_OS/Ubuntu)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo snap remove yarn 2>/dev/null || true
        rm -rf ~/.yarn 2>/dev/null || true
    fi
    
    # Use corepack to install yarn properly
    corepack enable 2>/dev/null || npm install -g corepack
    corepack prepare yarn@1.22.19 --activate
    
    # Verify installation
    if yarn --version >/dev/null 2>&1; then
        echo "Yarn installed successfully with corepack: $(yarn --version)"
    else
        echo "Yarn installation failed, will use npm instead"
    fi
}

setup_node() {
    echo "Using Node.js version from .nvmrc..."
    NODE_VERSION=$(cat .nvmrc)
    echo "Switching to Node.js $NODE_VERSION"
    nvm use $NODE_VERSION
    if [ $? -ne 0 ]; then
        echo "Installing Node.js $NODE_VERSION..."
        nvm install $NODE_VERSION
        nvm use $NODE_VERSION
    fi
    install_yarn
}

clean_all() {
    echo "Cleaning all dependencies and build artifacts..."
    # Stop any running services first
    stop_all
    # Clean all artifacts
    rm -rf node_modules packages/*/node_modules packages/*/dist packages/*/.next deploy yarn.lock package-lock.json
    # Clean package manager caches
    npm cache clean --force 2>/dev/null || true
    yarn cache clean 2>/dev/null || true
    echo "Clean complete!"
}

install_deps() {
    echo "Installing dependencies..."
    
    # Disable husky installation by removing postinstall scripts
    echo "Disabling husky to avoid git issues..."
    if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        # Windows Git Bash - use PowerShell for reliable text replacement
        for f in packages/*/package.json; do
            if [ -f "$f" ]; then
                powershell.exe -Command "(Get-Content '$f') -replace '\"husky install\"', '\"echo skipping husky install\"' | Set-Content '$f'" 2>/dev/null || true
            fi
        done
    else
        # Linux/WSL/Unix - use find with sed
        find packages -name "package.json" -exec sed -i 's/"husky install"/"echo skipping husky install"/g' {} \; 2>/dev/null || true
    fi
    
    # Set environment variables to skip husky
    export HUSKY=0
    export CI=true
    
    if yarn --version >/dev/null 2>&1; then
        yarn install --ignore-scripts
        if [ $? -ne 0 ]; then
            echo "Yarn failed, trying with npm..."
            npm install --ignore-scripts
        fi
    else
        npm install --ignore-scripts
    fi
    if [ $? -ne 0 ]; then
        echo "Failed to install dependencies"
        exit 1
    fi
}

start_all() {
    echo "Starting all microfrontends using lerna..."
    if yarn --version >/dev/null 2>&1; then
        yarn start
    else
        npm run start
    fi
}

build_all() {
    echo "Building all packages..."
    if yarn --version >/dev/null 2>&1; then
        yarn build
    else
        npm run build
    fi
    if [ $? -ne 0 ]; then
        echo "Build failed"
        exit 1
    fi
    echo "Build completed! Files in deploy/ directory"
}

stop_all() {
    echo "Stopping microfrontend services..."
    # Stop services by port
    for port in 9001 9002 9003 9004 4200; do
        if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
            # Windows Git Bash - use .exe executables
            pid=$(netstat.exe -ano 2>/dev/null | grep ":$port " | awk '{print $5}' | head -1)
            if [ -n "$pid" ] && [ "$pid" != "0" ]; then
                taskkill.exe //F //PID $pid >/dev/null 2>&1 && echo "Stopped service on port $port"
            fi
        elif [[ -f /proc/version ]] && grep -q Microsoft /proc/version; then
            # WSL - use Linux commands but may need different approach
            if command -v lsof >/dev/null 2>&1; then
                pid=$(lsof -ti:$port 2>/dev/null | head -1)
            elif command -v ss >/dev/null 2>&1; then
                pid=$(ss -tlnp 2>/dev/null | grep ":$port " | sed -n 's/.*pid=\([0-9]*\).*/\1/p' | head -1)
            elif command -v netstat >/dev/null 2>&1; then
                pid=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1 | head -1)
            fi
            if [ -n "$pid" ] && [ "$pid" != "0" ]; then
                kill -9 $pid 2>/dev/null && echo "Stopped service on port $port"
            fi
        else
            # Unix/Linux/macOS
            if command -v lsof >/dev/null 2>&1; then
                pid=$(lsof -ti:$port 2>/dev/null | head -1)
            elif command -v ss >/dev/null 2>&1; then
                pid=$(ss -tlnp 2>/dev/null | grep ":$port " | sed -n 's/.*pid=\([0-9]*\).*/\1/p' | head -1)
            elif command -v netstat >/dev/null 2>&1; then
                pid=$(netstat -tlnp 2>/dev/null | grep ":$port " | awk '{print $7}' | cut -d'/' -f1 | head -1)
            fi
            if [ -n "$pid" ] && [ "$pid" != "0" ]; then
                kill -9 $pid 2>/dev/null && echo "Stopped service on port $port"
            fi
        fi
    done
    echo "All microfrontend services stopped!"
}

start_individual() {
    echo "Select microfrontend to start:"
    echo "1. Root Config (Port 9001)"
    echo "2. Navbar (Port 9002)"
    echo "3. Employees (Port 9003)"
    echo "4. Home (Port 9004)"
    echo "5. Employee Details (Port 4200)"
    read -p "Enter choice (1-5): " choice
    
    case $choice in
        1) cd packages/single-spa-root-config && (yarn start 2>/dev/null || npm start) ;;
        2) cd packages/single-spa-navbar && (yarn start 2>/dev/null || npm start) ;;
        3) cd packages/single-spa-employees && (yarn start 2>/dev/null || npm start) ;;
        4) cd packages/single-spa-home && (yarn start 2>/dev/null || npm start) ;;
        5) cd packages/single-spa-employee-details && (yarn start 2>/dev/null || npm start) ;;
        *) echo "Invalid choice" ;;
    esac
}

case "$1" in
    setup)
        setup_node
        ;;
    clean)
        clean_all
        ;;
    build)
#        setup_node
#        clean_all
        install_deps
        build_all
        ;;
    stop)
        stop_all
        ;;
    individual)
        start_individual
        ;;
    *)
        echo "Single-SPA Microfrontend Manager"
        echo
#        setup_node
#        clean_all
        install_deps
        start_all
        echo
        echo "All microfrontends starting..."
        echo
        echo "🚀 Microfrontend Architecture Status:"
        echo "   📋 Root Config (Single-SPA):   http://localhost:9001"
        echo "   🧭 Navbar (React/JavaScript): http://localhost:9002"
        echo "   👥 Employees (React/TypeScript): http://localhost:9003"
        echo "   🏠 Home (React/TypeScript):     http://localhost:9004"
        echo "   👤 Employee Details (Angular 9): http://localhost:4200"
        echo
        echo "📱 Main Application: http://localhost:9001"
        echo "⚠️  Press Ctrl+C to stop all services"
        wait
        ;;
esac