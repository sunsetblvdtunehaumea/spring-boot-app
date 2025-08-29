@echo off
setlocal enabledelayedexpansion

REM Configuration files
set CONFIG_FILE=openshift_projects.txt
set CREDENTIALS_FILE=credentials.txt

echo.
echo  ██████╗ ██████╗ ███████╗███╗   ██╗███████╗██╗  ██╗██╗███████╗████████╗
echo ██╔═══██╗██╔══██╗██╔════╝████╗  ██║██╔════╝██║  ██║██║██╔════╝╚══██╔══╝
echo ██║   ██║██████╔╝█████╗  ██╔██╗ ██║███████╗███████║██║█████╗     ██║   
echo ██║   ██║██╔═══╝ ██╔══╝  ██║╚██╗██║╚════██║██╔══██║██║██╔══╝     ██║   
echo ╚██████╔╝██║     ███████╗██║ ╚████║███████║██║  ██║██║██║        ██║   
echo  ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   
echo.
echo                    Project Launcher with Saved Credentials
echo ═══════════════════════════════════════════════════════════════════════════
echo.

REM Check if projects configuration file exists
if not exist "%CONFIG_FILE%" (
    echo ❌ Projects file missing: %CONFIG_FILE%
    echo.
    echo 📝 Create %CONFIG_FILE% with format:
    echo    app_name^|environment^|full_openshift_url
    pause
    exit /b 1
)

REM Check if credentials file exists
if not exist "%CREDENTIALS_FILE%" (
    echo ❌ Credentials file missing: %CREDENTIALS_FILE%
    echo.
    echo 📝 Create %CREDENTIALS_FILE% with format:
    echo    server_hostname^|username^|password
    echo.
    echo 📋 Example:
    echo    openshift.cluster1.com^|john.doe^|mypassword123
    echo    openshift.cluster2.com^|jane.smith^|herpassword456
    pause
    exit /b 1
)

echo 📂 Loading projects from: %CONFIG_FILE%
echo 🔐 Loading credentials from: %CREDENTIALS_FILE%

REM Load credentials into memory
set cred_counter=0
for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%CREDENTIALS_FILE%") do (
    if not "%%a"=="" (
        if not "%%a:~0,1%"=="#" (
            set /a cred_counter+=1
            set "cred[!cred_counter!].server=%%a"
            set "cred[!cred_counter!].username=%%b"
            set "cred[!cred_counter!].password=%%c"
        )
    )
)

echo ✅ Loaded %cred_counter% credential set(s)

REM Load projects
set counter=0
for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%CONFIG_FILE%") do (
    if not "%%a"=="" (
        if not "%%a:~0,1%"=="#" (
            set /a counter+=1
            set "entry[!counter!].app=%%a"
            set "entry[!counter!].env=%%b"
            set "entry[!counter!].url=%%c"
        )
    )
)

if %counter% equ 0 (
    echo ❌ No valid projects found
    pause
    exit /b 1
)

echo ✅ Found %counter% project(s)
echo.

:show_menu
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                       Available Projects                       ║
echo ╠════╤═══════════════════╤═════════════╤═════════════════════════╣
echo ║ #  ║ Application       ║ Environment ║ Server                  ║
echo ╠════╪═══════════════════╪═════════════╪═════════════════════════╣

for /l %%i in (1,1,%counter%) do (
    set "app=!entry[%%i].app!                 "
    set "env=!entry[%%i].env!             "
    
    REM Extract server from URL for display
    set "url_temp=!entry[%%i].url!"
    for /f "tokens=3 delims=/" %%s in ("!url_temp!") do set "server=%%s"
    set "server=!server!                         "
    
    set "num=%%i  "
    echo ║ !num:~0,2! ║ !app:~0,17! ║ !env:~0,11! ║ !server:~0,23! ║
)

echo ╠════╪═══════════════════╪═════════════╪═════════════════════════╣
echo ║ 0  ║ Exit              ║             ║                         ║
echo ╚════╧═══════════════════╧═════════════╧═════════════════════════╝
echo.

:get_selection
set /p "choice=🎯 Select project number (0-%counter%): "

if "%choice%"=="0" (
    echo.
    echo 👋 Goodbye!
    goto :eof
)

REM Validate selection
set "valid_choice="
for /l %%i in (1,1,%counter%) do (
    if "%choice%"=="%%i" set "valid_choice=1"
)

if not defined valid_choice (
    echo.
    echo ❌ Invalid selection! Please choose a number between 0 and %counter%
    echo.
    goto get_selection
)

REM Get selected project details
set "selected_app=!entry[%choice%].app!"
set "selected_env=!entry[%choice%].env!"
set "selected_url=!entry[%choice%].url!"

echo.
echo ╔══════════════════════════════════════════════════════════════════╗
echo ║                        Selected Project                          ║
echo ╠══════════════════════════════════════════════════════════════════╣
echo ║ Application: %selected_app%
echo ║ Environment: %selected_env%
echo ║ URL: %selected_url%
echo ╚══════════════════════════════════════════════════════════════════╝
echo.

REM Extract server URL and hostname for credential lookup
for /f "tokens=1,2,3 delims=/" %%a in ("%selected_url%") do (
    set "server_url=%%a//%%c"
    set "server_hostname=%%c"
)

echo 🔍 Looking up credentials for: %server_hostname%

REM Find matching credentials
set "found_username="
set "found_password="

for /l %%i in (1,1,%cred_counter%) do (
    if /i "!cred[%%i].server!"=="%server_hostname%" (
        set "found_username=!cred[%%i].username!"
        set "found_password=!cred[%%i].password!"
        goto :found_creds
    )
)

REM If exact match not found, try partial matching
for /l %%i in (1,1,%cred_counter%) do (
    echo %server_hostname% | findstr /i "!cred[%%i].server!" >nul
    if !errorlevel! equ 0 (
        set "found_username=!cred[%%i].username!"
        set "found_password=!cred[%%i].password!"
        goto :found_creds
    )
)

:found_creds
if "%found_username%"=="" (
    echo ❌ No credentials found for server: %server_hostname%
    echo.
    echo Available servers in credentials file:
    for /l %%i in (1,1,%cred_counter%) do (
        echo    - !cred[%%i].server!
    )
    echo.
    echo 💡 Please add credentials for %server_hostname% to %CREDENTIALS_FILE%
    echo    Format: %server_hostname%^|your_username^|your_password
    echo.
    set /p "manual=Enter credentials manually for this session? (y/N): "
    if /i "%manual%"=="y" (
        set /p "found_username=Username: "
        set /p "found_password=Password: "
    ) else (
        goto show_menu
    )
)

echo ✅ Using credentials for user: %found_username%
echo 🔐 Server: %server_url%
echo.

echo 🔄 Authenticating...

REM Authenticate with found credentials
oc login "%server_url%" -u "%found_username%" -p "%found_password%" --insecure-skip-tls-verify >nul 2>&1

if %errorlevel% neq 0 (
    echo.
    echo ❌ Authentication failed!
    echo    Username: %found_username%
    echo    Server: %server_url%
    echo.
    echo 💡 Possible issues:
    echo    - Wrong credentials in %CREDENTIALS_FILE%
    echo    - Network connectivity problems
    echo    - Server URL incorrect
    echo.
    set /p "retry=🔄 Try with manual credentials? (y/N): "
    if /i "%retry%"=="y" (
        set /p "found_username=Username: "
        set /p "found_password=Password: "
        goto found_creds
    )
    echo.
    goto show_menu
)

echo ✅ Authentication successful!
for /f "tokens=*" %%a in ('oc whoami 2^>nul') do echo 👤 Logged in as: %%a
echo.

echo 🚀 Launching browser...
start "OpenShift - %selected_app% (%selected_env%)" "%selected_url%"

echo ✅ Browser launched for %selected_app% (%selected_env%)
echo 💡 You should now be authenticated in the OpenShift console
echo.

set /p "continue=🔄 Open another project? (y/N): "
if /i "%continue%"=="y" (
    echo.
    goto show_menu
)

echo.
echo 🎉 Session completed. Thank you!
pause
