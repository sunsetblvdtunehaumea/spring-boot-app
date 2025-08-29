@echo off
setlocal enabledelayedexpansion

REM Configuration files
set CONFIG_FILE=openshift_projects.txt
set CREDENTIALS_FILE=credentials_encoded.txt

echo OpenShift Project Launcher (Secure Credentials with Base64)
echo ==========================================================
echo.

REM Check files exist
if not exist "%CONFIG_FILE%" (
    echo ❌ Projects file missing: %CONFIG_FILE%
    echo 💡 Run the main launcher first to create sample files
    pause
    exit /b 1
)

if not exist "%CREDENTIALS_FILE%" (
    echo ❌ Encoded credentials file missing: %CREDENTIALS_FILE%
    echo.
    echo 📝 Create %CREDENTIALS_FILE% with format:
    echo    server_hostname^|username^|base64_encoded_password
    echo.
    echo 💡 Use encode_password.bat to generate encoded passwords
    pause
    exit /b 1
)

echo 📂 Loading projects from: %CONFIG_FILE%
echo 🔐 Loading encoded credentials from: %CREDENTIALS_FILE%

REM Load credentials with base64 decoding
set cred_counter=0
for /f "usebackq tokens=1,2,3 delims=|" %%a in ("%CREDENTIALS_FILE%") do (
    if not "%%a"=="" (
        if not "%%a:~0,1%"=="#" (
            set /a cred_counter+=1
            set "cred[!cred_counter!].server=%%a"
            set "cred[!cred_counter!].username=%%b"
            
            REM Decode base64 password using PowerShell
            for /f "tokens=*" %%p in ('powershell -command "try { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('%%c')) } catch { '%%c' }"') do (
                set "cred[!cred_counter!].password=%%p"
            )
        )
    )
)

echo ✅ Loaded %cred_counter% credential set(s) with decoded passwords

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
echo ║                Available Projects (Secure Mode)                ║
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
set /p "choice=🔐 Select project number (0-%counter%): "

if "%choice%"=="0" (
    echo.
    echo 🔐 Secure session ended. Goodbye!
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
    echo 💡 Please add credentials for %server_hostname% to %CREDENTIALS_FILE%
    echo    Use encode_password.bat to create encoded passwords
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

echo 🔄 Authenticating with decoded credentials...

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
    echo    - Password decoding failed
    echo    - Network connectivity problems
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
echo 🔐 Session authenticated with decoded credentials
echo.

set /p "continue=🔄 Open another project? (y/N): "
if /i "%continue%"=="y" (
    echo.
    goto show_menu
)

echo.
echo 🔐 Secure session completed. Thank you!
pause
