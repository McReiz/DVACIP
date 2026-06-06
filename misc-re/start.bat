@echo off
setlocal DisableDelayedExpansion

:: 1. Configuración de rutas
cd /d "%~dp0"
set "ORIGEN=espera"
set "DESTINO=listo"
set /a total=0

if not exist "%ORIGEN%" (echo [ERROR] No existe carpeta %ORIGEN% & pause & exit /b)
if not exist "%DESTINO%" mkdir "%DESTINO%"

echo Iniciando limpieza profunda y renombrado...
echo ---------------------------------------

:: 2. Bucle principal
for /f "delims=" %%F in ('dir /b /a-d "%ORIGEN%\*.mp3"') do (

    set "original_file=%%F"
    set "filename=%%~nF"
    set "ext=%%~xF"
    set /a total+=1

    :: --- LIMPIEZA CON POWERSHELL (Sintaxis Segura) ---
    :: Pasamos el nombre mediante una variable de entorno para evitar errores de comillas
    set "TEMP_NAME=%%~nF"
    for /f "delims=" %%N in ('powershell -NoProfile -Command ^
        "$n = $env:TEMP_NAME.Normalize('FormD') -replace '[\u0300-\u036f]', ''; ^
         $n = $n -replace ' \(SPOTISAVER\)', ''; ^
         $n = $n -replace '[^a-zA-Z0-9\s\.\-]', ''; ^
         $n.Trim()"') do set "clean_name=%%N"

    setlocal EnableDelayedExpansion
    
    :: --- INVERSIÓN ---
    for /f "tokens=1,2* delims=-" %%a in ("!clean_name!") do (
        set "artista=%%a"
        set "cancion=%%b"

        :: Limpiar espacios (Trim)
        if not "!cancion!"=="" (
            for /f "tokens=* delims= " %%i in ("!artista!") do set "artista=%%i"
            for /f "tokens=* delims= " %%j in ("!cancion!") do set "cancion=%%j"
            set "final_name=!cancion! - !artista!!ext!"
        ) else (
            set "final_name=!clean_name!!ext!"
        )

        echo [!total!] "%%F" -^> "!final_name!"
        
        :: Mover archivo usando rutas completas
        move /y "%~dp0%ORIGEN%\%%F" "%~dp0%DESTINO%\!final_name!" >nul
    )
    endlocal
)

echo ---------------------------------------
echo Proceso completado.
pause