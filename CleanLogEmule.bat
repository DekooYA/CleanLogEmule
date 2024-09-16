@echo off

chcp 65001>nul


cls

echo ==================================================
echo     ОЧИСТКА ЛОГОВ НА ВСЕХ ЭМУЛЯТОРАХ
echo ==================================================

set "LOG_PATH=/storage/emulated/0/Android/data/com.mega.app/files/LogFiles/*"


echo Проверка доступности ADB...
adb version >nul 2>&1
if %errorlevel% neq 0 (
    echo ADB не найден или не установлен. Убедитесь, что ADB добавлен в PATH.
    pause
    exit /b
)

set "DEVICES_FOUND=0"

setlocal enabledelayedexpansion

echo Получение списка запущенных устройств...
adb devices

for /f "skip=1 tokens=1,2 delims=	" %%a in ('adb devices') do (
    echo Обработка строки: %%a %%b
    if "%%b"=="device" (
        set "DEVICES_FOUND=1"
        echo Устройство найдено: %%a

        adb -s %%a get-state >nul 2>&1
        if !errorlevel! equ 0 (
            echo Подключение к устройству %%a успешно.

            echo Очистка логов в %LOG_PATH% на устройстве %%a...
            adb -s %%a shell rm -rf %LOG_PATH%

            if !errorlevel! equ 0 (
                echo Логи успешно очищены на устройстве %%a.
            ) else (
                echo Ошибка при очистке логов на устройстве %%a.
            )
        ) else (
            echo Не удалось подключиться к устройству %%a.
        )
    ) else (
        echo Игнорирование устройства с статусом: %%b
    )
)

if %DEVICES_FOUND% equ 0 (
    echo Нет подключенных устройств или эмуляторов.
)

echo ==================================================
echo               ОЧИСТКА ЗАВЕРШЕНА by @Dekoo
echo ==================================================

pause
