::[Bat To Exe Converter]
::
::YAwzoRdxOk+EWAnk
::fBw5plQjdG8=
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpCI=
::egkzugNsPRvcWATEpCI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZksaHErSXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlTMbCXqZg==
::ZQ05rAF9IAHYFVzEqQJQ
::eg0/rx1wNQPfEVWB+kM9LVsJDGQ=
::fBEirQZwNQPfEVWB+kM9LVsJDGQ=
::cRolqwZ3JBvQF1fEqQJQ
::dhA7uBVwLU+EWDk=
::YQ03rBFzNR3SWATElA==
::dhAmsQZ3MwfNWATEco/0r9O/yd5tubZIgXv8yf/aaQNnJLH0NA==
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCyDJGyX8VAjFDFVQgGjK0qGIrAP4/z0/9amhm8hVusxRI7L0fqLOOVz
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
setlocal DisableDelayedExpansion

set "MODE=install"
set "APK_PATH="
set "ADB_ARGS="
set "BASE=%~dp0"
set "AAPT=%BASE%aapt2.exe"
set "SEVENZIP=%BASE%7za.exe"
set "OUTDIR=%BASE%apkres"
set "TMPDIR=%BASE%tmp"
set "UNZIP_DIR=%TMPDIR%\unzip"
set "LOGDIR=%BASE%log"

if not exist "%LOGDIR%" mkdir "%LOGDIR%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

:parse
if "%~1"=="" goto :check
if /i "%~1"=="-u" (
    set "MODE=parse"
    shift & goto :parse
)
if /i "%~1"=="-d" (
    set "ADB_ARGS=%ADB_ARGS% -d"
    shift & goto :parse
)
if /i "%~1"=="-r" (
    set "ADB_ARGS=%ADB_ARGS% -r"
    shift & goto :parse
)
if /i "%~1"=="-t" (
    set "ADB_ARGS=%ADB_ARGS% -t"
    shift & goto :parse
)
if /i "%~1"=="-g" (
    set "ADB_ARGS=%ADB_ARGS% -g"
    shift & goto :parse
)
if /i "%~1"=="-s" (
    set "ADB_ARGS=%ADB_ARGS% -s"
    shift & goto :parse
)
if /i "%~1"=="-l" (
    set "ADB_ARGS=%ADB_ARGS% -l"
    shift & goto :parse
)
if /i "%~1"=="-f" (
    set "ADB_ARGS=%ADB_ARGS% -r -d -t"
    shift & goto :parse
)
if /i "%~1"=="-i" (
    set "ADB_ARGS=%ADB_ARGS% -i %2"
    shift & shift & goto :parse
)
if /i "%~1"=="--abi" (
    set "ADB_ARGS=%ADB_ARGS% --abi %2"
    shift & shift & goto :parse
)
if /i "%~1"=="-p" (
    set "ADB_ARGS=%ADB_ARGS% -p %2"
    shift & shift & goto :parse
)
if not defined APK_PATH (
    set "APK_PATH=%~1"
    shift & goto :parse
)
shift
goto :parse

:check
if not defined APK_PATH goto :usage

for %%a in ("%APK_PATH%") do set "EXT=%%~xa"

if /i "%EXT%"==".apk" (
    set "BASE_APK=%APK_PATH%"
    if "%MODE%"=="parse" goto :do_parse
    goto :install_direct
)

if not exist "%SEVENZIP%" goto :fail_sevenzip

if exist "%UNZIP_DIR%" rd /s /q "%UNZIP_DIR%"
mkdir "%UNZIP_DIR%" 2>nul
"%SEVENZIP%" x "%APK_PATH%" -o"%UNZIP_DIR%" -y >nul 2>&1
if errorlevel 1 goto :fail_extract

echo ===== UNZIP LIST ===== > "%LOGDIR%\apkdetaildebug.log"
dir /s /b "%UNZIP_DIR%" >> "%LOGDIR%\apkdetaildebug.log" 2>&1

if "%MODE%"=="parse" goto :find_base_parse
goto :find_base_install

:usage
echo Usage: apk [-u] [-d] [-r] [-t] [-g] [-s] [-l] [-f] [-i NAME] [-p NAME] [--abi ABI] ^<file^>
exit /b 1

:find_base_parse
set "BEST_APK="
set "BEST_LINES=0"

for /r "%UNZIP_DIR%" %%f in (*.apk) do (
    call :probe_apk "%%f"
)

if not defined BEST_APK goto :fail_nobase
set "BASE_APK=%BEST_APK%"
echo [INFO] Best APK: %BASE_APK% (%BEST_LINES% lines) >> "%LOGDIR%\apkdetaildebug.log"
goto :do_parse

:probe_apk
set "PROBE_FILE=%~1"
"%AAPT%" dump badging "%PROBE_FILE%" > "%TMPDIR%\probe.tmp" 2>nul
findstr /R /c:"^package:" "%TMPDIR%\probe.tmp" >nul 2>&1
if errorlevel 1 goto :probe_next

for /f %%c in ('find /c /v "" ^< "%TMPDIR%\probe.tmp"') do set "PROBE_LINES=%%c"

if %PROBE_LINES% gtr %BEST_LINES% (
    set "BEST_LINES=%PROBE_LINES%"
    set "BEST_APK=%PROBE_FILE%"
)
:probe_next
goto :eof

:find_base_install
set "BASE_APK="
if exist "%UNZIP_DIR%\base.apk" set "BASE_APK=%UNZIP_DIR%\base.apk"
if not defined BASE_APK if exist "%UNZIP_DIR%\base-master.apk" set "BASE_APK=%UNZIP_DIR%\base-master.apk"
if not defined BASE_APK for %%f in ("%UNZIP_DIR%\*.apk") do if not defined BASE_APK set "BASE_APK=%%f"
if not defined BASE_APK for /r "%UNZIP_DIR%" %%f in (*.apk) do if not defined BASE_APK set "BASE_APK=%%f"
if not defined BASE_APK goto :fail_nobase_install
goto :install_bundle

:do_parse
if not exist "%AAPT%" goto :fail_aapt

echo 0>"%LOGDIR%\apkdetailpercent.log"
echo ===== %DATE% %TIME% =====>>"%LOGDIR%\apkdetaildebug.log"
echo SRC=%APK_PATH%>>"%LOGDIR%\apkdetaildebug.log"
echo BASE=%BASE_APK%>>"%LOGDIR%\apkdetaildebug.log"

if not exist "%TMPDIR%" mkdir "%TMPDIR%" 2>nul
if exist "%TMPDIR%\badging.tmp" del /q "%TMPDIR%\badging.tmp" 2>nul
if exist "%TMPDIR%\probe.tmp" del /q "%TMPDIR%\probe.tmp" 2>nul
if exist "%OUTDIR%\*.txt" del /q "%OUTDIR%\*.txt"

"%AAPT%" dump badging "%BASE_APK%" > "%TMPDIR%\badging.tmp" 2>>"%LOGDIR%\apkdetaildebug.log"

findstr /R /c:"^package:" "%TMPDIR%\badging.tmp" >nul 2>&1
if errorlevel 1 goto :fail_parse

echo 70>"%LOGDIR%\apkdetailpercent.log"

for /f "tokens=2 delims='" %%a in ('findstr /R /c:"^package:" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\package_name.txt"
for /f "tokens=4 delims='" %%a in ('findstr /R /c:"^package:" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\version_code.txt"
for /f "tokens=6 delims='" %%a in ('findstr /R /c:"^package:" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\version_name.txt"

for /f "tokens=2 delims='" %%a in ('findstr /c:"application-label:'" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\app_name.txt"
if not exist "%OUTDIR%\app_name.txt" (
    for /f "tokens=2 delims='" %%a in ('findstr /c:" label='" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\app_name.txt"
)

for /f "tokens=2 delims='" %%a in ('findstr /R /c:"sdkVersion:'[0-9]*'" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\min_sdk.txt"
for /f "tokens=2 delims='" %%a in ('findstr /R /c:"targetSdkVersion:'[0-9]*'" "%TMPDIR%\badging.tmp"') do echo %%a > "%OUTDIR%\target_sdk.txt"

findstr /R /c:"uses-permission" "%TMPDIR%\badging.tmp" > "%OUTDIR%\permissions.txt"
if %errorlevel% neq 0 echo no permissions>"%OUTDIR%\permissions.txt"

echo 100>"%LOGDIR%\apkdetailpercent.log"
echo apk detail finished>"%LOGDIR%\apkdetail.log"
exit /b 0

:install_direct
echo adb install%ADB_ARGS% "%APK_PATH%" > "%LOGDIR%\install.log"
adb install%ADB_ARGS% "%APK_PATH%" >> "%LOGDIR%\install.log" 2>&1
exit /b 0

:install_bundle
setlocal EnableDelayedExpansion
set "ALL_APKS=%BASE_APK%"

for /r "%UNZIP_DIR%" %%f in (*.apk) do (
    if not "%%f"=="%BASE_APK%" (
        set "ALL_APKS=!ALL_APKS! "%%f""
    )
)

echo adb install-multiple%ADB_ARGS% !ALL_APKS! > "%LOGDIR%\install.log"
adb install-multiple%ADB_ARGS% !ALL_APKS! >> "%LOGDIR%\install.log" 2>&1
endlocal
exit /b 0

:fail_aapt
echo [ERROR] aapt2.exe not found >> "%LOGDIR%\apkdetaildebug.log"
echo apk detail failed>"%LOGDIR%\apkdetail.log"
exit /b 1

:fail_sevenzip
echo [ERROR] 7za.exe not found > "%LOGDIR%\install.log"
exit /b 1

:fail_extract
echo [ERROR] Extract failed > "%LOGDIR%\install.log"
exit /b 1

:fail_nobase
echo [ERROR] No valid base.apk found >> "%LOGDIR%\apkdetaildebug.log"
echo apk detail failed>"%LOGDIR%\apkdetail.log"
exit /b 1

:fail_nobase_install
echo [ERROR] No base.apk found > "%LOGDIR%\install.log"
exit /b 1

:fail_parse
echo [ERROR] aapt2 parse failed >> "%LOGDIR%\apkdetaildebug.log"
echo apk detail failed>"%LOGDIR%\apkdetail.log"
exit /b 1