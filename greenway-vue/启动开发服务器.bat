@echo off
chcp 65001 >nul
echo.
echo ====================================
echo   北京绿道系统 Vue 版本
echo   启动开发服务器...
echo ====================================
echo.

REM 进入项目目录
cd /d "%~dp0"

REM 检查 node_modules 是否存在
if not exist "node_modules" (
    echo [错误] 依赖未安装
    echo 请先运行 "安装依赖.bat"
    pause
    exit /b 1
)

echo [√] 正在启动开发服务器...
echo.
echo 浏览器会自动打开 http://localhost:5173
echo.
echo 按 Ctrl+C 停止服务器
echo.
echo ====================================
echo.

call npm run dev

pause
