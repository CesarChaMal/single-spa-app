@echo off
echo Select microfrontend to start:
echo.
echo 1. Root Config (Port 9001)
echo 2. Navbar (Port 9002)
echo 3. Employees (Port 9003)
echo 4. Home (Port 9004)
echo 5. Employee Details (Port 4200)
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" (
    echo Starting Root Config...
    cd packages\single-spa-root-config
    yarn start
) else if "%choice%"=="2" (
    echo Starting Navbar...
    cd packages\single-spa-navbar
    yarn start
) else if "%choice%"=="3" (
    echo Starting Employees...
    cd packages\single-spa-employees
    yarn start
) else if "%choice%"=="4" (
    echo Starting Home...
    cd packages\single-spa-home
    yarn start
) else if "%choice%"=="5" (
    echo Starting Employee Details...
    cd packages\single-spa-employee-details
    yarn start
) else (
    echo Invalid choice. Please run the script again.
    pause
)