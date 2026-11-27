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
::cxY6rQJ7JhzQF1fEqQJhZksaHUrTXA==
::ZQ05rAF9IBncCkqN+0xwdVsFAlTMbSXrZg==
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
::Zh4grVQjdCyDJGyX8VAjFDFVQgGjK0qGIrAP4/z0/9amhm8hVusxRIzU17mPLuRd713hFQ==
::YB416Ek+ZW8=
::
::
::978f952a14a936cc963da21a135fa983
echo off
title 极简ADB工具箱命令行工具
cd .\bin
cls
echo.
echo    极简ADB工具箱命令行工具
echo.
echo ##########快捷命令##########
echo.
echo 检测设备连接
echo adb devices
echo fastboot devices
echo.
echo 解锁引导加载程序
echo fastboot oem unlock
echo fastboot flashing unlock
echo fastboot oem unlock-go
echo.
echo 解锁关键分区（部分设备）
echo fastboot oem unlock_critical
echo fastboot flashing unlock_critical
echo.
echo 回锁引导加载程序（注意！是回锁！）
echo fastboot oem lock
echo fastboot flashing lock
echo.
echo 回锁关键分区（部分设备；注意！是回锁！）
echo fastboot oem lock_critical
echo fastboot flashing lock_critical
echo.
echo 刷入镜像分区
echo fastboot flash {分区名} {镜像文件路径}
echo Tips:常用分区：
echo        init_boot/boot/recovery/system/super
echo.
echo 重启命令
echo adb reboot {模式}
echo fastboot reboot {模式}
echo Tips:fastboot到恢复模式需要加短横杠
echo        fastboot reboot-recovery
echo        常用模式：
echo        bootloader/fastboot/edl/recovery/正常模式（不需要模式字段）
echo.
echo 执行adb命令
echo adb {命令}
echo adb shell {Android命令}
echo.
echo 使用愉快
echo.
echo ############################
call cmd