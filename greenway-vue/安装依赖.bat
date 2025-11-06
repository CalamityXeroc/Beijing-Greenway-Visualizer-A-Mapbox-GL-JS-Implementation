@echo off
chcp 65001 >nul
cls
echo.
echo ========================================
echo   北京绿道系统 Vue 版本 - 环境检查
echo ========================================
echo.

REM 检查 Node.js 是否安装
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [X] 错误：未检测到 Node.js
    echo.
    echo Node.js 是运行本项目的必需环境。
    echo.
    echo 请按照以下步骤安装：
    echo.
    echo 方法1：推荐 - 使用官方安装包
    echo   1. 访问: https://nodejs.org/
    echo   2. 下载 LTS 版本（推荐 v18 或 v20）
    echo   3. 运行安装程序，全部保持默认选项
    echo   4. 安装完成后重启命令行窗口
    echo   5. 再次运行本脚本
    echo.
    echo 方法2：使用 Chocolatey（如果已安装）
    echo   打开管理员 PowerShell 运行：
    echo   choco install nodejs-lts
    echo.
    echo 安装完成后，请重新运行本脚本。
    echo.
    pause
    exit /b 1
)

echo [√] Node.js 版本:
node -v
echo.

echo [√] npm 版本:
npm -v
echo.

REM 进入项目目录
cd /d "%~dp0"

echo ====================================
echo 步骤 1: 安装依赖包...
echo ====================================
echo.

call npm install

if %errorlevel% neq 0 (
    echo.
    echo [错误] 依赖安装失败
    echo 尝试清除缓存后重试...
    call npm cache clean --force
    call npm install
)

echo.
echo ====================================
echo 步骤 2: 复制数据文件...
echo ====================================
echo.

REM 创建 public 目录
if not exist "public" mkdir public

REM 复制数据文件夹
if exist "..\数据" (
    xcopy "..\数据" "public\数据\" /E /I /Y >nul 2>&1
    if %errorlevel% equ 0 (
        echo [√] 数据文件复制成功
    ) else (
        echo [!] 数据文件复制失败，请手动复制
    )
) else (
    echo [!] 未找到数据文件夹，请确保 ..\数据 目录存在
)

echo.
echo ====================================
echo 安装完成！
echo ====================================
echo.
echo 下一步：
echo 1. 运行 "启动开发服务器.bat" 启动项目
echo 2. 或者手动执行: npm run dev
echo.

pause
