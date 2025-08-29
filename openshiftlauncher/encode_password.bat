@echo off
setlocal enabledelayedexpansion

echo Password Encoder for OpenShift Launcher
echo =======================================
echo.
echo This utility encodes passwords in Base64 for secure storage.
echo.

:encode_loop
set /p "plain_password=Enter password to encode (or 'quit' to exit): "

if /i "%plain_password%"=="quit" (
    echo Goodbye!
    goto :eof
)

if "%plain_password%"=="" (
    echo ❌ Please enter a password
    goto encode_loop
)

REM Encode using PowerShell
for /f "tokens=*" %%e in ('powershell -command "[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes('%plain_password%'))"') do (
    set "encoded_password=%%e"
)

echo.
echo ═══════════════════════════════════════════
echo Original Password: %plain_password%
echo Encoded Password:  %encoded_password%
echo ═══════════════════════════════════════════
echo.

echo 📋 Copy this for your credentials file:
echo server_hostname^|username^|%encoded_password%
echo.

set /p "another=Encode another password? (y/N): "
if /i "%another%"=="y" (
    echo.
    goto encode_loop
)

echo.
echo 💡 Remember to update your launcher script to use Base64 decoding
echo    if you want to use encoded passwords!
echo.
pause
