#!/bin/bash

echo "Starting all microfrontends..."
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
echo "Starting all microfrontends in parallel..."
cd packages/single-spa-root-config && yarn start &
sleep 3
cd ../single-spa-navbar && yarn start &
sleep 3
cd ../single-spa-home && yarn start &
sleep 3
cd ../single-spa-employees && yarn start &
sleep 3
cd ../single-spa-employee-details && yarn start &

echo
echo "All microfrontends are starting..."
echo "Root Config will be available at: http://localhost:9001"
echo
echo "Press Ctrl+C to stop all services"
wait