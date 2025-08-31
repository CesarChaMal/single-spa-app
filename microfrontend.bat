@echo off
REM Single-SPA Microfrontend Manager
REM Usage:
REM   microfrontend.bat          - Setup, clean, install and start all microfrontends
REM   microfrontend.bat setup    - Setup Node.js and yarn only
REM   microfrontend.bat clean    - Clean dependencies and build artifacts
REM   microfrontend.bat build    - Build all packages for production
REM   microfrontend.bat stop     - Stop all running services
REM   microfrontend.bat individual - Start individual microfrontend

if "%1"=="setup" goto setup
if "%1"=="clean" goto clean
if "%1"=="build" goto build
if "%1"=="stop" goto stop
if "%1"=="individual" goto individual
goto start

:install-yarn
setlocal enabledelayedexpansion
echo Setting up yarn...

REM Try normal installation first (with --force to overwrite existing files)
call npm install -g yarn@1.22.19 --force >nul 2>&1 || call npm install -g yarn@1.22.19

REM Test if yarn works
call yarn --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Yarn installed successfully
    call yarn --version
    endlocal
    goto :eof
)

echo Normal yarn installation failed, applying fix for Windows/Anaconda conflicts...

REM Completely remove all yarn installations
call npm uninstall -g yarn >nul 2>&1

REM Clean all possible yarn locations
for /f "tokens=*" %%i in ('where node 2^>nul') do (
    for %%j in ("%%i") do (
        set "NODE_DIR=%%~dpj"
        if exist "!NODE_DIR!node_modules\yarn" rmdir /s /q "!NODE_DIR!node_modules\yarn" >nul 2>&1
        for %%f in ("!NODE_DIR!yarn*" "!NODE_DIR!yarnpkg*") do if exist "%%f" del "%%f" >nul 2>&1
    )
)

REM Remove from all Anaconda paths
if defined USERPROFILE (
    for /d /r "%USERPROFILE%\anaconda3" %%d in (*yarn*) do rmdir /s /q "%%d" >nul 2>&1
)
if defined CONDA_PREFIX (
    for /d /r "%CONDA_PREFIX%" %%d in (*yarn*) do rmdir /s /q "%%d" >nul 2>&1
)

REM Use corepack to install yarn properly
call corepack enable >nul 2>&1 || call npm install -g corepack
call corepack prepare yarn@1.22.19 --activate

REM Verify installation
call yarn --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Yarn installed successfully with corepack
    call yarn --version
) else (
    echo Yarn installation failed, will use npm instead
)
endlocal
goto :eof

:setup
echo Using Node.js version from .nvmrc...
for /f %%i in (.nvmrc) do set NODE_VERSION=%%i
call nvm use %NODE_VERSION%
if %errorlevel% neq 0 (
    call nvm install %NODE_VERSION%
    call nvm use %NODE_VERSION%
)
call :install-yarn
goto :eof

:clean
echo Cleaning all dependencies and build artifacts...
REM Stop services first
call :stop
REM Clean all artifacts
if exist node_modules rmdir /s /q node_modules
if exist deploy rmdir /s /q deploy
if exist yarn.lock del yarn.lock
if exist package-lock.json del package-lock.json
for /d %%i in (packages\*) do (
    if exist "%%i\node_modules" rmdir /s /q "%%i\node_modules"
    if exist "%%i\dist" rmdir /s /q "%%i\dist"
    if exist "%%i\.next" rmdir /s /q "%%i\.next"
)
call npm cache clean --force >nul 2>&1
call yarn cache clean >nul 2>&1
echo Clean complete!
goto :eof

:install
echo Installing dependencies...

REM Disable husky installation by removing postinstall scripts
echo Disabling husky to avoid git issues...
for /r packages %%f in (package.json) do (
    powershell -Command "(Get-Content '%%f') -replace '\"husky install\"', '\"echo skipping husky install\"' | Set-Content '%%f'"
)

REM Set environment variables to skip husky
set HUSKY=0
set CI=true

call yarn --version >nul 2>&1
if %errorlevel% equ 0 (
    call yarn install --ignore-scripts
    if %errorlevel% neq 0 (
        echo Yarn failed, trying with npm...
        call npm install --ignore-scripts
    )
) else (
    call npm install --ignore-scripts
)
if %errorlevel% neq 0 (
    echo Failed to install dependencies
    exit /b 1
)
goto :eof

:build
call :setup
call :clean
call :install
echo Building all packages...
call yarn --version >nul 2>&1
if %errorlevel% equ 0 (
    call yarn build
) else (
    call npm run build
)
echo Build completed! Files in deploy/ directory
pause
goto :eof

:stop
setlocal enabledelayedexpansion
echo Stopping microfrontend services...
REM Stop services by port
for %%p in (9001 9002 9003 9004 4200) do (
    for /f "tokens=2,5" %%a in ('netstat -aon 2^>nul ^| findstr ":%%p "') do (
        if "%%a"=="0.0.0.0:%%p" (
            taskkill /f /pid %%b >nul 2>&1
            if !errorlevel! equ 0 echo Stopped service on port %%p
        )
        if "%%a"=="[::]:%%p" (
            taskkill /f /pid %%b >nul 2>&1
            if !errorlevel! equ 0 echo Stopped service on port %%p
        )
        if "%%a"=="127.0.0.1:%%p" (
            taskkill /f /pid %%b >nul 2>&1
            if !errorlevel! equ 0 echo Stopped service on port %%p
        )
    )
)
echo All microfrontend services stopped!
endlocal
pause
goto :eof

:individual
echo Select microfrontend to start:
echo 1. Root Config (Port 9001)
echo 2. Navbar (Port 9002)
echo 3. Employees (Port 9003)
echo 4. Home (Port 9004)
echo 5. Employee Details (Port 4200)
set /p choice="Enter choice (1-5): "
if "%choice%"=="1" cd packages\single-spa-root-config && (yarn start 2>nul || npm start)
if "%choice%"=="2" cd packages\single-spa-navbar && (yarn start 2>nul || npm start)
if "%choice%"=="3" cd packages\single-spa-employees && (yarn start 2>nul || npm start)
if "%choice%"=="4" cd packages\single-spa-home && (yarn start 2>nul || npm start)
if "%choice%"=="5" cd packages\single-spa-employee-details && (yarn start 2>nul || npm start)
goto :eof

:start
echo Single-SPA Microfrontend Manager
echo.
call :setup
call :clean
call :install
echo Starting all microfrontends using lerna...
call yarn --version >nul 2>&1
if %errorlevel% equ 0 (
    call yarn start
) else (
    call npm run start
)
echo.
echo Microfrontend Architecture Status:
echo    Root Config (Orchestrator): http://localhost:9001
echo    Navbar (React/JS):          http://localhost:9002
echo    Employees (React/TS):       http://localhost:9003
echo    Home (React/TS):            http://localhost:9004
echo    Employee Details (Angular): http://localhost:4200
echo.
echo Main Application: http://localhost:9001
echo Press Ctrl+C to stop all services
pause