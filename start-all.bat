@echo off
echo Starting all microfrontends...
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
echo Starting all microfrontends in parallel...
start "Root Config" cmd /k "cd packages\single-spa-root-config && yarn start"
timeout /t 3 /nobreak >nul
start "Navbar" cmd /k "cd packages\single-spa-navbar && yarn start"
timeout /t 3 /nobreak >nul
start "Home" cmd /k "cd packages\single-spa-home && yarn start"
timeout /t 3 /nobreak >nul
start "Employees" cmd /k "cd packages\single-spa-employees && yarn start"
timeout /t 3 /nobreak >nul
start "Employee Details" cmd /k "cd packages\single-spa-employee-details && yarn start"

echo.
echo All microfrontends are starting...
echo Root Config will be available at: http://localhost:9001
echo.
echo Press any key to exit...
pause >nul