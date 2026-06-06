@echo off
setlocal enabledelayedexpansion

:: 1. Solicitar el UUID opcional al usuario
set /p "UUID_INPUT=Introduce el disc_patter_uuid (Opcional, pulsa Enter para saltar): "

:: Ruta de la carpeta de entrada
set "INPUT_DIR=./inputs"

:: 2. Bucle que recorre los archivos
for %%F in ("%INPUT_DIR%\*") do (
    echo.
    echo --------------------------------------------------
    echo Procesando: %%~nxF
    
    :: Si el usuario escribió un UUID, lo pasamos en el comando
    if not "!UUID_INPUT!"=="" (
        python _inputs-to-outputs--audacity.py --mp3_name="%%~nF" --disc_patter_uuid="!UUID_INPUT!"
    ) else (
        :: Si no escribió nada, se ejecuta sin ese argumento
        python _inputs-to-outputs--audacity.py --mp3_name="%%~nF"
    )
)

echo.
echo ¡Proceso finalizado!
pause