@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

REM Crear carpetas si no existen
if not exist "espera" mkdir espera
if not exist "listo" mkdir listo

echo Procesando archivos...
echo.

REM Procesar cada archivo en la carpeta "espera"
for %%F in (espera\*) do (
    set "archivo=%%~nxF"
    set "sinext=%%~nF"
    set "extension=%%~xF"
    
    set "nuevo=!sinext!"
    
    REM Eliminar (SPOTISAVER)
    set "nuevo=!nuevo: (SPOTISAVER)=!"
    set "nuevo=!nuevo:(SPOTISAVER)=!"
    
    REM Limpiar espacios extras
    set "nuevo=!nuevo:  = !"
    
    REM Invertir si tiene " - "
    for /f "tokens=1* delims=-" %%A in ("!nuevo!") do (
        set "parte1=%%A"
        set "parte2=%%B"
    )
    
    if not "!parte2!"=="" (
        REM Limpiar espacios en ambas partes
        for /f "tokens=*" %%X in ("!parte1!") do set "parte1=%%X"
        for /f "tokens=*" %%X in ("!parte2!") do set "parte2=%%X"
        set "nuevo=!parte2! - !parte1!"
    )
    
    REM Renombrar y mover
    if not "!nuevo!"=="" (
        ren "espera\!archivo!" "!nuevo!!extension!" 2>nul
        if exist "espera\!nuevo!!extension!" (
            move "espera\!nuevo!!extension!" "listo\!nuevo!!extension!" >nul 2>&1
            echo [OK] !archivo! --^> !nuevo!!extension!
        )
    )
)

echo.
echo Proceso completado. Archivos en la carpeta "listo"
pause
