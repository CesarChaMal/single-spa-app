@echo off
echo Building all microfrontends for production...
echo.

echo Using Node.js version from .nvmrc...
for /f %%i in (.nvmrc) do set NODE_VERSION=%%i
call nvm use %NODE_VERSION%
if %errorlevel% neq 0 (
    echo Installing Node.js %NODE_VERSION%...
    call nvm install %NODE_VERSION%
    call nvm use %NODE_VERSION%
)

echo Installing dependencies...
call yarn install
if %errorlevel% neq 0 (
    echo Failed to install dependencies
    exit /b 1
)

echo.
echo Building all packages...
call yarn build
if %errorlevel% neq 0 (
    echo Build failed
    exit /b 1
)

echo.
echo Build completed successfully!
echo Files are available in the deploy/ directory
echo.
echo To serve the production build, run: yarn serve
pause