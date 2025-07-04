@echo off
where docker >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Docker not found. Please install Docker Desktop.
    pause
    exit /b
)

echo [+] Pulling Docker image...
docker pull lucifer251/serverconsole:latest

echo [+] Running container...
docker run --rm -it -p 443:443 lucifer251/serverconsole:latest

pause