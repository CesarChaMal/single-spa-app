#!/bin/bash

echo "Building all microfrontends for production..."
echo

echo "Using Node.js version from .nvmrc..."
nvm use
if [ $? -ne 0 ]; then
    echo "Failed to switch Node version. Installing..."
    nvm install
    nvm use
fi

echo "Installing dependencies..."
yarn install
if [ $? -ne 0 ]; then
    echo "Failed to install dependencies"
    exit 1
fi

echo
echo "Building all packages..."
yarn build
if [ $? -ne 0 ]; then
    echo "Build failed"
    exit 1
fi

echo
echo "Build completed successfully!"
echo "Files are available in the deploy/ directory"
echo
echo "To serve the production build, run: yarn serve"