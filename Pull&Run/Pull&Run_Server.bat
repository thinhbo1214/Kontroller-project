@echo off
echo === Starting Server Console Docker Container ===

REM Kiểm tra Docker đã cài chưa
where docker >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Docker not found. Please install Docker Desktop.
    pause
    exit /b
)

REM Thiết lập thông số
SET CONTAINER_NAME=ServerConsole
SET IMAGE=lucifer251/serverconsole:latest
SET PORT=443

REM Kiểm tra container đã tồn tại chưa
docker ps -a --format "{{.Names}}" | findstr /I %CONTAINER_NAME% >nul
IF %ERRORLEVEL%==0 (
    echo [+] Container "%CONTAINER_NAME%" already exists. Starting it...
    docker start -ai %CONTAINER_NAME%
) ELSE (
    echo [+] Pulling image: %IMAGE%
    docker pull %IMAGE%

    echo [+] Creating and starting container "%CONTAINER_NAME%"...
    docker run -it -p %PORT%:443 --name %CONTAINER_NAME% %IMAGE%
)

pause