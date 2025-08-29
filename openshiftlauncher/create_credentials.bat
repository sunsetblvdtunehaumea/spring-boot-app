@echo off
setlocal enabledelayedexpansion

set CRED_FILE=credentials.txt

echo OpenShift Credential File Generator
echo ===================================
echo.

echo This will create/update: %CRED_FILE%
echo.

if exist "%CRED_FILE%" (
    echo 📄 Current credentials file:
    echo ════════════════════════════════
    type %CRED_FILE%
    echo ════════════════════════════════
    echo.
    
    set /p "append=Add to existing file? (y/N): "
    if /i not "%append%"=="y" (
        echo Creating new file...
        echo # OpenShift Credentials Configuration > %CRED_FILE%
        echo # Format: server_hostname^|username^|password >> %CRED_FILE%
        echo # Lines starting with # are comments >> %CRED_FILE%
        echo. >> %CRED_FILE%
    )
) else (
    echo Creating new credentials file...
    echo # OpenShift Credentials Configuration > %CRED_FILE%
    echo # Format: server_hostname^|username^|password >> %CRED_FILE%
    echo # Lines starting with # are comments >> %CRED_FILE%
    echo. >> %CRED_FILE%
)

:add_credential
echo.
echo ➕ Adding New Credential
echo ═══════════════════════
set /p "server=Server hostname (e.g., openshift.cluster1.com): "

if "%server%"=="" (
    echo ❌ Server hostname cannot be empty
    goto add_credential
)

set /p "username=Username: "

if "%username%"=="" (
    echo ❌ Username cannot be empty
    goto add_credential
)

set /p "password=Password: "

if "%password%"=="" (
    echo ❌ Password cannot be empty
    goto add_credential
)

echo.
echo ✅ Credential Summary:
echo ═════════════════════
echo Server:   %server%
echo Username: %username%
echo Password: %password%
echo.

set /p "confirm=Add this credential? (y/N): "
if /i not "%confirm%"=="y" (
    echo Credential cancelled.
    goto add_credential
)

REM Append to credentials file
echo %server%^|%username%^|%password% >> %CRED_FILE%

echo ✅ Credential added to %CRED_FILE%
echo.

set /p "another=Add another credential? (y/N): "
if /i "%another%"=="y" goto add_credential

echo.
echo 📄 Final credentials file contents:
echo ═══════════════════════════════════
type %CRED_FILE%
echo ═══════════════════════════════════
echo.

echo ✅ Credential file updated successfully!
echo.
echo 💡 Usage Tips:
echo   - Keep this file secure (contains passwords)
echo   - Use same server hostnames as in your project URLs
echo   - You can manually edit the file if needed
echo   - Consider using the encode_password.bat for better security
echo.

pause
