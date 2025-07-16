@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Tên file cài đặt XAMPP
set "SETUP_EXE=xampp-windows-x64-8.2.12-0-VS16-installer.exe"
:: Đường cài mặc định
set "XAMPP_DIR=C:\xampp"
set "XAMPP_EXE=%XAMPP_DIR%\xampp-control.exe"
set "SHORTCUT=start_xampp.lnk"

echo ========================================
echo    XAMPP Auto Setup and Launcher
echo ========================================

:: Kiểm tra XAMPP đã được cài chưa
if exist "%XAMPP_EXE%" (
    echo XAMPP đã được cài tại %XAMPP_DIR%
    echo Đang khởi động XAMPP Control Panel...
    start "" "%XAMPP_EXE%"
    goto :eof
)

:: Nếu chưa có, kiểm tra file cài
if exist "%~dp0%SETUP_EXE%" (
    echo Chưa phát hiện XAMPP.
    echo Đang chạy trình cài đặt: %SETUP_EXE%
    echo Vui lòng cài vào đúng đường dẫn: %XAMPP_DIR%
    pause
    start "" "%~dp0%SETUP_EXE%"
    echo.
    echo Khi cài xong, chạy lại file này để khởi động XAMPP.
) else (
    echo Không tìm thấy file cài đặt: %SETUP_EXE%
    echo Hãy đặt file cài đặt cùng thư mục với file .bat này.
)

pause
exit /b
