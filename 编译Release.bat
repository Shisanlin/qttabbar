@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem ============================================================
rem  QTTabBar 正式版(Release)编译脚本
rem  依次编译：主程序、C++ Hook 库、InstallerHelper、SetHome、所有插件
rem ============================================================

set "MSBUILD=D:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
set "ROOT=%~dp0"
set "CFG=/p:Configuration=Release /p:SolutionDir=%ROOT%"

if not exist "%MSBUILD%" (
    echo [错误] 找不到 MSBuild: "%MSBUILD%"
    echo 请确认 Visual Studio 2022 安装路径后修改本脚本中的 MSBUILD 变量。
    exit /b 1
)

echo ============================================================
echo  1/5  编译 QTTabBar 主程序 ^(含 BandObjectLib / QTPluginLib^)
echo ============================================================
"%MSBUILD%" "%ROOT%QTTabBar\QTTabBar.csproj" /t:Build %CFG% /v:minimal /nologo
if errorlevel 1 goto :err

echo ============================================================
echo  2/5  编译 C++ Hook 库 ^(QTHookLib，含 32/64 位^)
echo ============================================================
"%MSBUILD%" "%ROOT%QTHookLib\QTHookLib.vcxproj" /t:Build /p:Configuration=Release /p:Platform=Win32 /v:minimal /nologo
if errorlevel 1 goto :err

echo ============================================================
echo  3/5  编译 InstallerHelper ^(C++^)
echo ============================================================
"%MSBUILD%" "%ROOT%InstallerHelper\InstallerHelper.vcxproj" /t:Build /p:Configuration=Release /p:Platform=Win32 /v:minimal /nologo
if errorlevel 1 goto :err

echo ============================================================
echo  4/5  编译 SetHome
echo ============================================================
"%MSBUILD%" "%ROOT%SetHome\SetHome.csproj" /t:Build %CFG% /v:minimal /nologo
if errorlevel 1 goto :err

echo ============================================================
echo  5/5  编译所有插件 ^(Plugins^)
echo ============================================================
for /d %%P in ("%ROOT%Plugins\*") do (
    for %%F in ("%%P\*.csproj") do (
        echo --- %%~nxF ---
        "%MSBUILD%" "%%F" /t:Build %CFG% /v:minimal /nologo
        if errorlevel 1 goto :err
    )
)

echo.
echo ============================================================
echo                  ★ 编译成功 ★
echo  接下来可运行  打包MSI.bat  生成安装包
echo ============================================================
exit /b 0

:err
echo.
echo ************************************************************
echo                  × 编译失败 ×  ^(见上方错误信息^)
echo ************************************************************
exit /b 1
