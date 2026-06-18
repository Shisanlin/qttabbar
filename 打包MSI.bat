@echo off
chcp 65001 >nul
setlocal

rem ============================================================
rem  QTTabBar 安装包(MSI)打包脚本
rem  生成完整版安装包(含插件)。请先运行 编译Release.bat
rem ============================================================

set "MSBUILD=D:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
set "ROOT=%~dp0"
set "WIX=C:\Program Files (x86)\WiX Toolset v3.14\"

if not exist "%MSBUILD%" (
    echo [错误] 找不到 MSBuild: "%MSBUILD%"
    exit /b 1
)
if not exist "%WIX%bin\candle.exe" (
    echo [错误] 找不到 WiX Toolset: "%WIX%"
    echo 请先安装 WiX Toolset v3.14，或修改本脚本中的 WIX 变量。
    exit /b 1
)

echo ============================================================
echo  打包完整版 MSI ^(Installer^)
echo ============================================================
"%MSBUILD%" "%ROOT%Installer\Installer.wixproj" /t:Rebuild /p:Configuration=Release /p:SolutionDir=%ROOT% /v:minimal /nologo
if errorlevel 1 goto :err

echo.
echo ============================================================
echo                  ★ 打包成功 ★
echo  安装包^(各语言^)位于:
echo    %ROOT%Installer\bin\Release\zh-CN\QTTabBar Setup.msi
echo    %ROOT%Installer\bin\Release\en-US\QTTabBar Setup.msi
echo ============================================================
explorer "%ROOT%Installer\bin\Release\zh-CN"
exit /b 0

:err
echo.
echo ************************************************************
echo                  × 打包失败 ×  ^(见上方错误信息^)
echo ************************************************************
exit /b 1
