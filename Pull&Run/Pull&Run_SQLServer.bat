@echo off
echo === Starting SQL Server Docker Container ===

REM Kiểm tra Docker đã cài chưa
where docker >nul 2>nul
IF %ERRORLEVEL% NEQ 0 (
    echo [!] Docker not found. Please install Docker Desktop.
    pause
    exit /b
)

REM Thiết lập thông số
SET CONTAINER_NAME=sqlserver
SET SA_PASSWORD=svcntt
SET IMAGE=mcr.microsoft.com/mssql/server:2022-latest
SET PORT=1433

REM Kiểm tra container đã tồn tại chưa
docker ps -a --format "{{.Names}}" | findstr /I %CONTAINER_NAME% >nul
IF %ERRORLEVEL%==0 (
    echo [+] Container "%CONTAINER_NAME%" already exists. Starting it...
    docker start %CONTAINER_NAME%
) ELSE (
    echo [+] Pulling image: %IMAGE%
    docker pull %IMAGE%

    echo [+] Creating and starting container "%CONTAINER_NAME%"...
    docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=%SA_PASSWORD%" ^
        -p %PORT%:1433 --name %CONTAINER_NAME% -d %IMAGE%
)

echo [*] SQL Server is running on port %PORT%.
echo [*] Username: sa
echo [*] Password: %SA_PASSWORD%
echo [*] To stop it later: docker stop %CONTAINER_NAME%
pause
